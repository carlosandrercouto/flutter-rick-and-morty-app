import 'dart:developer';

import '../enums/api_response_status_enum.dart';
import '../entities/api_response.dart';

/// Helper centralizado de respostas mockadas para o app Rick and Morty.
class MockHelper {
  static final MockHelper _instance = MockHelper();
  static MockHelper get instance => _instance;

  static const Duration _mockDelay = Duration(milliseconds: 800);

  final Map<String, _MockHandler> _mocks = {};

  static const List<String> _mockedPrefixes = [
    '/episode/',
    '/character/',
  ];

  bool shouldMockRoute(String endpoint) =>
      _mocks.containsKey(endpoint) ||
      _mockedPrefixes.any((p) => endpoint.startsWith(p));

  Future<ApiResponse> call({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    log('Mock called for endpoint: $endpoint', name: 'MockHelper');
    await Future.delayed(_mockDelay);

    final handler = _mocks[endpoint];
    if (handler != null) return handler(body ?? {});

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

typedef _MockHandler = ApiResponse Function(Map<String, dynamic> body);
