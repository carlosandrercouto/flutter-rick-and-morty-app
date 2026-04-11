// ignore_for_file: camel_case_types

import '../../../core/enums/api_request_type_enum.dart';

/// Centralização de todos os endpoints da API do template.
///
/// Segue o mesmo padrão do projeto monetizze:
/// cada valor do enum carrega o [ApiRequestType] e a [url] do endpoint,
/// evitando que o método HTTP fique espalhado pelo código.
///
/// Exemplo de uso:
/// ```dart
/// final endpoint = ApiEndpoints.postLogin;
/// print(endpoint.requestType); // ApiRequestType.POST
/// print(endpoint.url);         // /auth/login
/// ```
enum ApiEndpoints {
  // Feature login : Login
  // ===================================================================================================================
  postLogin(ApiRequestType.POST, '/auth/login'),
  postResetPassword(ApiRequestType.POST, '/auth/reset-password'),
  ;

  // Não altere os parâmetros
  final ApiRequestType requestType;
  final String url;

  const ApiEndpoints(this.requestType, this.url);
}
