import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../enums/api_request_type_enum.dart';
import '../enums/api_response_status_enum.dart';
import '../helpers/environment_helper.dart';
import '../helpers/mock_helper.dart';
import '../helpers/session_helper.dart';
import '../shared/domain/entities/api_response.dart';

part 'api_request.dart';

/// Serviço centralizado de HTTP.
///
/// - Recebe [ApiRequest] com o tipo de requisição, headers, params e body
/// - Retorna [ApiResponse] com status padronizado
///
/// Centralizado em `core/services/`, endpoints centralizados em
/// `core/services/apis/api_endpoints.dart`.
class ApiService {
  final http.Client _httpClient;
  final EnvironmentHelper _envHelper;

  ApiService({EnvironmentHelper? envHelper, http.Client? httpClient})
    : _envHelper = envHelper ?? EnvironmentHelper.instance,
      _httpClient = httpClient ?? http.Client();

  static ApiService get instance => ApiService();

  /// Executa uma requisição HTTP.
  ///
  /// Exemplo de uso de requisição:
  /// ```dart
  /// final ApiResponse response = await _apiService(
  ///   endpoint: endpoint.url,
  ///   request: ApiRequest(requestType: endpoint.requestType, body: body),
  ///   devLog: 'LoginDatasource: login',
  ///   currentStackTrace: StackTrace.current,
  /// );
  /// ```
  Future<ApiResponse> call({
    required String endpoint,
    required ApiRequest request,
    required String devLog,
    required StackTrace currentStackTrace,
    int apiRequestTimeout = 30,
  }) async {
    if (_envHelper.useMock) {
      return MockHelper.instance.call(
        endpoint: endpoint,
        body: request.body is Map<String, dynamic>
            ? request.body as Map<String, dynamic>
            : {},
      );
    }

    final url = Uri.parse('${_envHelper.apiBaseUrl}$endpoint').replace(
      queryParameters: request.params?.isNotEmpty == true
          ? request.params
          : null,
    );

    final String? sessionToken = SessionHelper.instance.isAuthenticated
        ? SessionHelper.instance.token
        : null;

    final Map<String, String> resolvedHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (sessionToken != null) 'Authorization': 'Bearer $sessionToken',
      ...?request.headers,
    };

    try {
      final http.Response response = await _sendRequest(
        requestType: request.requestType,
        url: url,
        headers: resolvedHeaders,
        body: request.body,
        timeoutSeconds: apiRequestTimeout,
      );

      final dynamic decoded = jsonDecode(response.body);
      final Map<String, dynamic> result = decoded is Map<String, dynamic>
          ? decoded
          : {'data': decoded};

      if (response.statusCode == 200 || response.statusCode == 201) {
        dev.log('Success', name: devLog);
        return ApiResponse(status: ApiResponseStatus.success, result: result);
      } else if (response.statusCode == 401) {
        dev.log('Error [${response.statusCode}]: $result', name: devLog);

        return ApiResponse(
          status: ApiResponseStatus.errorSessionExpired,
          result: result,
        );
      } else {
        dev.log('Error [${response.statusCode}]: $result', name: devLog);

        /// TODO: Implementar gravação de log de erro no Crashlytics ou simular
        return ApiResponse(
          status: ApiResponseStatus.errorStatusCode,
          result: result,
        );
      }
    } on TimeoutException {
      dev.log('Timeout', name: devLog);
      return ApiResponse(status: ApiResponseStatus.errorTimeout);
    } on SocketException {
      dev.log('SocketException (offline?)', name: devLog);
      return ApiResponse(status: ApiResponseStatus.errorTimeout);
    } on FormatException {
      dev.log('FormatException (bad JSON)', name: devLog);

      /// TODO: Implementar gravação de log de erro no Crashlytics ou simular
      return ApiResponse(status: ApiResponseStatus.errorJsonDecode);
    } catch (e) {
      dev.log('Unknown error: $e', name: devLog);

      /// TODO: Implementar gravação de log de erro no Crashlytics ou simular
      return ApiResponse(status: ApiResponseStatus.errorGeneric);
    }
  }

  Future<http.Response> _sendRequest({
    required ApiRequestType requestType,
    required Uri url,
    required Map<String, String> headers,
    required Object body,
    required int timeoutSeconds,
  }) async {
    final duration = Duration(seconds: timeoutSeconds);
    final encodedBody = body is Map ? jsonEncode(body) : body.toString();

    switch (requestType) {
      case ApiRequestType.GET:
        return _httpClient.get(url, headers: headers).timeout(duration);
      case ApiRequestType.POST:
        return _httpClient
            .post(url, headers: headers, body: encodedBody)
            .timeout(duration);
      case ApiRequestType.PUT:
        return _httpClient
            .put(url, headers: headers, body: encodedBody)
            .timeout(duration);
    }
  }
}
