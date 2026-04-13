// ignore_for_file: camel_case_types

import '../../../core/enums/api_request_type_enum.dart';

/// Centralização de todos os endpoints da API do app Rick and Morty.
enum ApiEndpoints {
  getEpsodios(ApiRequestType.GET, '/episode'),
  getCharacters(ApiRequestType.GET, '/character'),
  ;

  // Não altere os parâmetros
  final ApiRequestType requestType;
  final String url;

  const ApiEndpoints(this.requestType, this.url);
}
