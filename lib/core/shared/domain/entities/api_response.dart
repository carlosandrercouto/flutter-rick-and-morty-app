import '../../../enums/api_response_status_enum.dart';

/// Representa a resposta padronizada de uma chamada de API.
class ApiResponse {
  final ApiResponseStatus status;
  final Map<String, dynamic>? result;

  ApiResponse({
    required this.status,
    this.result,
  });
}
