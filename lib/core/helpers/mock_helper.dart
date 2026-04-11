import 'dart:developer';

import '../enums/api_response_status_enum.dart';
import '../shared/domain/entities/api_response.dart';

/// Helper centralizado de respostas mockadas.
///
/// Simula o comportamento do [ApiService] retornando [ApiResponse]
/// baseado na [url] do endpoint acessado.
///
/// Cada entrada do mapa [_mocks] corresponde a uma URL definida
/// em [ApiEndpoints], mapeando para uma função que recebe o [body]
/// e retorna o resultado mockado.
///
/// Para adicionar um novo mock basta incluir uma entrada em [_mocks]
/// com a URL do endpoint como chave.
class MockHelper {
  static final MockHelper _instance = MockHelper();
  static MockHelper get instance => _instance;

  /// Simula a latência de rede.
  static const Duration _mockDelay = Duration(milliseconds: 800);

  /// Mapa de mocks indexado pela URL do endpoint.
  ///
  /// Chave: [ApiEndpoints.url]
  /// Valor: função que recebe o body da requisição e retorna o resultado
  final Map<String, _MockHandler> _mocks = {
    // ── Login ──────────────────────────────────────────────────────────────
    '/auth/login': _handleLogin,
    '/auth/reset-password': _handleResetPassword,
  };

  /// Retorna a [ApiResponse] mockada para o [endpoint] informado.
  ///
  /// Se não houver mock cadastrado para o endpoint, retorna erro genérico.
  Future<ApiResponse> call({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    log('Mock called for endpoint: $endpoint', name: 'MockHelper');
    await Future.delayed(_mockDelay);

    final handler = _mocks[endpoint];

    if (handler == null) {
      log('Mock not found for endpoint: $endpoint', name: 'MockHelper');
      return ApiResponse(status: ApiResponseStatus.errorGeneric);
    }

    return handler(body ?? {});
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _users = [
    {
      'token': 'mock-token-abc123',
      'userId': 'user-001',
      'name': 'Usuário Teste',
      'email': 'user@test.com',
      'password': '123456',
    },
    {
      'token': 'mock-token-def456',
      'userId': 'user-002',
      'name': 'Admin Template',
      'email': 'admin@template.com',
      'password': 'admin123',
    },
  ];

  static ApiResponse _handleLogin(Map<String, dynamic> body) {
    final user = _users.cast<Map<String, dynamic>?>().firstWhere(
      (u) => u!['email'] == body['email'] && u['password'] == body['password'],
      orElse: () => null,
    );

    if (user == null) {
      return ApiResponse(
        status: ApiResponseStatus.success,
        result: {
          'token': '',
          'userId': '',
          'name': '',
          'email': body['email'] ?? '',
          'error': 'Usuário ou Senha Inválidos',
        },
      );
    }

    return ApiResponse(
      status: ApiResponseStatus.success,
      result: {
        'token': user['token'],
        'userId': user['userId'],
        'name': user['name'],
        'email': user['email'],
      },
    );
  }

  static ApiResponse _handleResetPassword(Map<String, dynamic> body) {
    return ApiResponse(
      status: ApiResponseStatus.success,
      result: {'message': 'E-mail de recuperação enviado com sucesso.'},
    );
  }
}

/// Tipo da função handler de mock.
typedef _MockHandler = ApiResponse Function(Map<String, dynamic> body);
