import 'dart:developer';

import '../enums/api_response_status_enum.dart';
import '../entities/api_response.dart';

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

    // ── Home ───────────────────────────────────────────────────────────────
    '/home/transactions': _handleGetTransactions,
  };

  /// Prefixos de endpoints que possuem mock (para rotas com IDs dinâmicos).
  static const List<String> _mockedPrefixes = [
    '/episode/',
    '/character/',
  ];

  /// Verifica se a rota especificada possui um mock cadastrado.
  bool shouldMockRoute(String endpoint) =>
      _mocks.containsKey(endpoint) ||
      _mockedPrefixes.any((p) => endpoint.startsWith(p));

  /// Retorna a [ApiResponse] mockada para o [endpoint] informado.
  ///
  /// Se não houver mock cadastrado para o endpoint, retorna erro genérico.
  Future<ApiResponse> call({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    log('Mock called for endpoint: $endpoint', name: 'MockHelper');
    await Future.delayed(_mockDelay);

    // Tenta match exato primeiro
    final handler = _mocks[endpoint];
    if (handler != null) return handler(body ?? {});

    // Depois tenta por prefixo
    if (endpoint.startsWith('/episode/')) {
      return _handleGetEpsode(endpoint);
    }
    if (endpoint.startsWith('/character/')) {
      return _handleGetCharacters(endpoint);
    }

    log('Mock not found for endpoint: $endpoint', name: 'MockHelper');
    return ApiResponse(status: ApiResponseStatus.errorGeneric);
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

  static ApiResponse _handleGetTransactions(Map<String, dynamic> body) {
    return ApiResponse(
      status: ApiResponseStatus.success,
      result: {
        'balance': {
          'available': 4820.00,
          'incomes': 6200.00,
          'expenses': 1380.00,
        },
        'transactions': [
          {
            'id': 'txn-001',
            'name': 'Supermercado Extra',
            'amount': 347.80,
            'date': '2024-03-15T10:30:00Z',
          },
          {
            'id': 'txn-002',
            'name': 'Netflix',
            'amount': 55.90,
            'date': '2024-03-14T08:00:00Z',
          },
          {
            'id': 'txn-003',
            'name': 'Posto Shell',
            'amount': 210.00,
            'date': '2024-03-13T17:45:00Z',
          },
          {
            'id': 'txn-004',
            'name': 'Farmácia Pacheco',
            'amount': 89.50,
            'date': '2024-03-12T11:20:00Z',
          },
          {
            'id': 'txn-005',
            'name': 'iFood',
            'amount': 63.40,
            'date': '2024-03-11T20:15:00Z',
          },
          {
            'id': 'txn-006',
            'name': 'Spotify',
            'amount': 21.90,
            'date': '2024-03-10T08:00:00Z',
          },
          {
            'id': 'txn-007',
            'name': 'Amazon',
            'amount': 189.99,
            'date': '2024-03-09T14:32:00Z',
          },
        ],
      },
    );
  }

  static ApiResponse _handleGetEpsode(String endpoint) {
    return ApiResponse(
      status: ApiResponseStatus.success,
      result: {
        'id': 28,
        'name': 'The Ricklantis Mixup',
        'air_date': 'September 10, 2017',
        'episode': 'S03E07',
        'characters': [
          'https://rickandmortyapi.com/api/character/1',
          'https://rickandmortyapi.com/api/character/2',
          'https://rickandmortyapi.com/api/character/4',
          'https://rickandmortyapi.com/api/character/5',
          'https://rickandmortyapi.com/api/character/6',
          'https://rickandmortyapi.com/api/character/18',
          'https://rickandmortyapi.com/api/character/21',
          'https://rickandmortyapi.com/api/character/22',
        ],
        'url': 'https://rickandmortyapi.com/api/episode/28',
        'created': '2017-11-10T12:56:36.965Z',
      },
    );
  }

  static const List<Map<String, dynamic>> _allCharacters = [
    {
      'id': 1,
      'name': 'Rick Sanchez',
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Male',
      'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      'origin': {'name': 'Earth (C-137)'},
      'location': {'name': 'Citadel of Ricks'},
    },
    {
      'id': 2,
      'name': 'Morty Smith',
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Male',
      'image': 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
      'origin': {'name': 'Earth (C-137)'},
      'location': {'name': 'Citadel of Ricks'},
    },
    {
      'id': 4,
      'name': 'Beth Smith',
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Female',
      'image': 'https://rickandmortyapi.com/api/character/avatar/4.jpeg',
      'origin': {'name': 'Earth (C-137)'},
      'location': {'name': 'Earth (Replacement Dimension)'},
    },
    {
      'id': 5,
      'name': 'Jerry Smith',
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Male',
      'image': 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
      'origin': {'name': 'Earth (C-137)'},
      'location': {'name': 'Citadel of Ricks'},
    },
    {
      'id': 6,
      'name': 'Abadango Cluster Princess',
      'status': 'Alive',
      'species': 'Alien',
      'gender': 'Female',
      'image': 'https://rickandmortyapi.com/api/character/avatar/6.jpeg',
      'origin': {'name': 'Abadango'},
      'location': {'name': 'Abadango'},
    },
    {
      'id': 18,
      'name': 'Antenna Morty',
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Male',
      'image': 'https://rickandmortyapi.com/api/character/avatar/18.jpeg',
      'origin': {'name': 'unknown'},
      'location': {'name': 'Citadel of Ricks'},
    },
    {
      'id': 21,
      'name': 'Aqua Morty',
      'status': 'unknown',
      'species': 'Humanoid',
      'gender': 'Male',
      'image': 'https://rickandmortyapi.com/api/character/avatar/21.jpeg',
      'origin': {'name': 'unknown'},
      'location': {'name': 'Citadel of Ricks'},
    },
    {
      'id': 22,
      'name': 'Aqua Rick',
      'status': 'unknown',
      'species': 'Humanoid',
      'gender': 'Male',
      'image': 'https://rickandmortyapi.com/api/character/avatar/22.jpeg',
      'origin': {'name': 'unknown'},
      'location': {'name': 'Citadel of Ricks'},
    },
  ];

  static ApiResponse _handleGetCharacters(String endpoint) {
    // Extrai os IDs da URL: /character/1,2,3
    final idsSegment =
        endpoint.replaceFirst('/character/', '').replaceAll(' ', '');
    final requestedIds = idsSegment
        .split(',')
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toSet();

    final filtered = _allCharacters
        .where((c) => requestedIds.contains(c['id'] as int))
        .toList();

    return ApiResponse(
      status: ApiResponseStatus.success,
      result: {'data': filtered},
    );
  }
}

/// Tipo da função handler de mock.
typedef _MockHandler = ApiResponse Function(Map<String, dynamic> body);
