part of 'api_service.dart';

/// Encapsula os dados de uma requisição HTTP.
///
/// Segue o padrão do monetizze — `part of` api_service.dart.
class ApiRequest {
  final Map<String, String>? headers;
  final Map<String, String>? params;
  final Object body;
  final ApiRequestType requestType;

  ApiRequest({
    required this.requestType,
    this.headers,
    this.body = const {},
    this.params,
  });
}
