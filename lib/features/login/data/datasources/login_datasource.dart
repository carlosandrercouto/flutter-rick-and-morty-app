import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/entities/api_response.dart';

import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/login_repository.dart';
import '../models/models_export.dart';

/// Datasource de login.
///
/// Arquitetura do Datasource:
/// - Extends o repositório abstrato diretamente
/// - Recebe [ApiService] como dependência injetável no construtor
/// - Cada método: seleciona o endpoint no enum → chama _apiService (ou mock) →
///   trata [ApiResponseStatus] → mapeia com o model
class LoginDatasource extends LoginRepository {
  final ApiService _apiService;

  LoginDatasource({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  @override
  Future<Either<Failure?, UserLoginData>> postRequestLogin({
    required String email,
    required String password,
  }) async {
    final ApiEndpoints endpoint = ApiEndpoints.postLogin;

    final ApiResponse apiResponse = await _apiService(
      endpoint: endpoint.url,
      request: ApiRequest(
        requestType: endpoint.requestType,
        body: {'email': email, 'password': password},
      ),
      devLog: 'LoginDatasource: postRequestLogin',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final UserLoginData result = UserLoginDataModel.fromMap(
          map: apiResponse.result!,
        );
        return Future.value(Right(result));
      } catch (error) {
        log(
          'Error: ${error.toString()}',
          name: 'LoginDatasource: postRequestLogin',
        );

        /// TODO: Implementar gravação de log de erro no Crashlytics ou simular
        return Future.value(const Left(null));
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Future.value(Left(TimeoutFailure()));
    } else if (apiResponse.status == ApiResponseStatus.errorSessionExpired) {
      return Future.value(Left(SessionExpiredFailure()));
    }

    return Future.value(const Left(null));
  }
}
