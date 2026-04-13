import 'dart:convert';

import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/enums/cache_source_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/helpers/database_helper.dart';
import 'package:flutter_template/core/services/api_service.dart';
import 'package:flutter_template/core/entities/api_response.dart';
import 'package:flutter_template/features/home/data/datasources/home_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Mocks ───────────────────────────────────────────────────────────────────

class MockApiService implements ApiService {
  ApiResponse? result;
  String? lastEndpoint;

  @override
  Future<ApiResponse> call({
    required String endpoint,
    required ApiRequest request,
    required String devLog,
    required StackTrace currentStackTrace,
    int apiRequestTimeout = 30,
  }) async {
    lastEndpoint = endpoint;
    return result ?? ApiResponse(status: ApiResponseStatus.errorGeneric);
  }
}

/// Fake do DatabaseHelper que armazena entradas em memória.
///
/// Implementa [DatabaseHelperBase] evitando depender do tipo [Database] do
/// sqflite nos testes.
class FakeDatabaseHelper implements DatabaseHelperBase {
  final Map<String, CacheEntry> _store = {};

  /// Controla se as entradas serão tratadas como válidas (dentro do TTL).
  bool entriesAreValid;

  FakeDatabaseHelper({this.entriesAreValid = false});

  /// Insere diretamente uma entrada serializada no store em memória.
  void seed({required String key, required Map<String, dynamic> data}) {
    _store[key] = CacheEntry(
      key: key,
      jsonData: jsonEncode(data),
      // se válido → updatedAt agora; se inválido → 2 minutos atrás
      updatedAt: entriesAreValid
          ? DateTime.now()
          : DateTime.now().subtract(const Duration(minutes: 2)),
    );
  }

  /// Insere diretamente uma lista serializada no store em memória.
  void seedList({
    required String key,
    required List<Map<String, dynamic>> data,
  }) {
    _store[key] = CacheEntry(
      key: key,
      jsonData: jsonEncode(data),
      updatedAt: entriesAreValid
          ? DateTime.now()
          : DateTime.now().subtract(const Duration(minutes: 2)),
    );
  }

  @override
  Future<CacheEntry?> get({required String key}) async => _store[key];

  @override
  Future<void> upsert({required String key, required String jsonData}) async {
    _store[key] = CacheEntry(
      key: key,
      jsonData: jsonData,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> delete({required String key}) async => _store.remove(key);

  @override
  Future<void> clearAll() async => _store.clear();
}

// ── Fixtures ─────────────────────────────────────────────────────────────────

const tEpsodeApiMap = {
  'id': 28,
  'name': 'The Ricklantis Mixup',
  'air_date': 'September 10, 2017',
  'episode': 'S03E07',
  'characters': ['https://rickandmortyapi.com/api/character/1'],
};

const tEpsodeCacheMap = {
  'id': 28,
  'name': 'The Ricklantis Mixup',
  'air_date': 'September 10, 2017',
  'episode': 'S03E07',
  'characters': [1],
};

const tCharacterApiMap = {
  'id': 1,
  'name': 'Rick Sanchez',
  'status': 'Alive',
  'species': 'Human',
  'gender': 'Male',
  'image': '',
  'origin': {'name': 'Earth'},
  'location': {'name': 'Earth'},
};

const tCharacterCacheMap = {
  'id': 1,
  'name': 'Rick Sanchez',
  'status': 'Alive',
  'species': 'Human',
  'gender': 'Male',
  'image_url': '',
  'origin_name': 'Earth',
  'location_name': 'Earth',
};

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late MockApiService mockApiService;
  late FakeDatabaseHelper fakeDb;
  late HomeDatasource datasource;

  setUp(() {
    mockApiService = MockApiService();
    fakeDb = FakeDatabaseHelper();
    datasource = HomeDatasource(
      apiService: mockApiService,
      databaseHelper: fakeDb,
    );
  });

  group('HomeDatasource', () {
    group('getEpsode', () {
      // ── Cache HIT ──────────────────────────────────────────────────────────

      group('cache HIT (TTL válido)', () {
        setUp(() => fakeDb.entriesAreValid = true);

        test(
          'should return Right(Epsode) from cache without calling API',
          () async {
            fakeDb.seed(key: 'episode_28', data: tEpsodeCacheMap);

            final result = await datasource.getEpsode(id: 28);

            expect(result.isRight(), isTrue);
            result.fold(
              (_) => fail('Expected Right'),
              (epsode) {
                expect(epsode.id, 28);
                expect(epsode.name, 'The Ricklantis Mixup');
              },
            );
            // API não foi chamada
            expect(mockApiService.lastEndpoint, isNull);
          },
        );

        test('should set lastEpsodeSource to local on cache hit', () async {
          fakeDb.seed(key: 'episode_28', data: tEpsodeCacheMap);

          await datasource.getEpsode(id: 28);

          expect(datasource.lastEpsodeSource, CacheSource.local);
        });
      });

      // ── Cache MISS ──────────────────────────────────────────────────────────

      group('cache MISS (sem cache ou TTL expirado)', () {
        test('should call API and return Right(Epsode) on success', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: tEpsodeApiMap,
          );

          final result = await datasource.getEpsode(id: 28);

          expect(result.isRight(), isTrue);
          result.fold(
            (_) => fail('Expected Right'),
            (epsode) {
              expect(epsode.id, 28);
              expect(epsode.characters, [1]);
            },
          );
        });

        test('should build the correct endpoint URL', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: tEpsodeApiMap,
          );

          await datasource.getEpsode(id: 28);

          expect(mockApiService.lastEndpoint, contains('/episode/28'));
        });

        test('should persist result in cache after API call', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: tEpsodeApiMap,
          );

          await datasource.getEpsode(id: 28);

          final cached = await fakeDb.get(key: 'episode_28');
          expect(cached, isNotNull);
          expect(cached!.jsonData, contains('"id":28'));
        });

        test('should set lastEpsodeSource to remote on cache miss', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: tEpsodeApiMap,
          );

          await datasource.getEpsode(id: 28);

          expect(datasource.lastEpsodeSource, CacheSource.remote);
        });

        test(
          'should also call API when cache is expired (TTL > 1min)',
          () async {
            // Cache expirado
            fakeDb.entriesAreValid = false;
            fakeDb.seed(key: 'episode_28', data: tEpsodeCacheMap);

            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: tEpsodeApiMap,
            );

            await datasource.getEpsode(id: 28);

            expect(mockApiService.lastEndpoint, isNotNull);
            expect(datasource.lastEpsodeSource, CacheSource.remote);
          },
        );

        test('should return Left(TimeoutFailure) on timeout', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.errorTimeout,
          );

          final result = await datasource.getEpsode(id: 28);

          expect(result.isLeft(), isTrue);
          result.fold(
            (f) => expect(f, isA<TimeoutFailure>()),
            (_) => fail('Expected Left'),
          );
        });

        test(
          'should return Left(SessionExpiredFailure) on session expired',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.errorSessionExpired,
            );

            final result = await datasource.getEpsode(id: 28);

            expect(result.isLeft(), isTrue);
            result.fold(
              (f) => expect(f, isA<SessionExpiredFailure>()),
              (_) => fail('Expected Left'),
            );
          },
        );

        test('should return Left(null) on generic error', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.errorGeneric,
          );

          final result = await datasource.getEpsode(id: 28);

          expect(result.isLeft(), isTrue);
          result.fold(
            (f) => expect(f, isNull),
            (_) => fail('Expected Left'),
          );
        });

        test(
          'should return Left(null) when parsing throws (malformed map)',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: {'id': 'not-an-int'},
            );

            final result = await datasource.getEpsode(id: 28);

            expect(result.isLeft(), isTrue);
          },
        );
      });
    });

    // ── getCharacters ─────────────────────────────────────────────────────────

    group('getCharacters', () {
      group('cache HIT (TTL válido)', () {
        setUp(() => fakeDb.entriesAreValid = true);

        test(
          'should return Right(characters) from cache without calling API',
          () async {
            fakeDb.seedList(
              key: 'characters_1',
              data: [tCharacterCacheMap],
            );

            final result = await datasource.getCharacters(ids: [1]);

            expect(result.isRight(), isTrue);
            result.fold(
              (_) => fail('Expected Right'),
              (chars) {
                expect(chars, hasLength(1));
                expect(chars.first.name, 'Rick Sanchez');
              },
            );
            expect(mockApiService.lastEndpoint, isNull);
          },
        );

        test('should set lastCharactersSource to local on cache hit', () async {
          fakeDb.seedList(
            key: 'characters_1',
            data: [tCharacterCacheMap],
          );

          await datasource.getCharacters(ids: [1]);

          expect(datasource.lastCharactersSource, CacheSource.local);
        });
      });

      group('cache MISS', () {
        test('should build endpoint with a single ID', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: {
              'data': [tCharacterApiMap],
            },
          );

          await datasource.getCharacters(ids: [1]);

          expect(mockApiService.lastEndpoint, contains('/character/1'));
        });

        test(
          'should build endpoint with multiple IDs joined by comma',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: {'data': <Map<String, dynamic>>[]},
            );

            await datasource.getCharacters(ids: [1, 2, 3]);

            expect(mockApiService.lastEndpoint, contains('1,2,3'));
          },
        );

        test(
          'should return Right(List<CharacterEntity>) on success with data list',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: {
                'data': [tCharacterApiMap],
              },
            );

            final result = await datasource.getCharacters(ids: [1]);

            expect(result.isRight(), isTrue);
            result.fold(
              (_) => fail('Expected Right'),
              (chars) {
                expect(chars, hasLength(1));
                expect(chars.first.id, 1);
                expect(chars.first.name, 'Rick Sanchez');
              },
            );
          },
        );

        test(
          'should return Right with single character when API returns bare map',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: tCharacterApiMap,
            );

            final result = await datasource.getCharacters(ids: [1]);

            expect(result.isRight(), isTrue);
            result.fold(
              (_) => fail('Expected Right'),
              (chars) => expect(chars, hasLength(1)),
            );
          },
        );

        test(
          'should return characters sorted alphabetically by name',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: {
                'data': [
                  {...tCharacterApiMap, 'id': 2, 'name': 'Morty Smith'},
                  {...tCharacterApiMap, 'id': 1, 'name': 'Rick Sanchez'},
                  {...tCharacterApiMap, 'id': 3, 'name': 'Beth Smith'},
                ],
              },
            );

            final result = await datasource.getCharacters(ids: [1, 2, 3]);

            result.fold(
              (_) => fail('Expected Right'),
              (chars) {
                expect(chars[0].name, 'Beth Smith');
                expect(chars[1].name, 'Morty Smith');
                expect(chars[2].name, 'Rick Sanchez');
              },
            );
          },
        );

        test('should persist result in cache after API call', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: {
              'data': [tCharacterApiMap],
            },
          );

          await datasource.getCharacters(ids: [1]);

          final cached = await fakeDb.get(key: 'characters_1');
          expect(cached, isNotNull);
          expect(cached!.jsonData, contains('"Rick Sanchez"'));
        });

        test(
          'should set lastCharactersSource to remote on cache miss',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.success,
              result: {
                'data': [tCharacterApiMap],
              },
            );

            await datasource.getCharacters(ids: [1]);

            expect(datasource.lastCharactersSource, CacheSource.remote);
          },
        );

        test('should return Left(TimeoutFailure) on timeout', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.errorTimeout,
          );

          final result = await datasource.getCharacters(ids: [1]);

          expect(result.isLeft(), isTrue);
          result.fold(
            (f) => expect(f, isA<TimeoutFailure>()),
            (_) => fail('Expected Left'),
          );
        });

        test(
          'should return Left(SessionExpiredFailure) on session expired',
          () async {
            mockApiService.result = ApiResponse(
              status: ApiResponseStatus.errorSessionExpired,
            );

            final result = await datasource.getCharacters(ids: [1]);

            expect(result.isLeft(), isTrue);
            result.fold(
              (f) => expect(f, isA<SessionExpiredFailure>()),
              (_) => fail('Expected Left'),
            );
          },
        );

        test('should return Left(null) on generic error', () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.errorGeneric,
          );

          final result = await datasource.getCharacters(ids: [1]);

          expect(result.isLeft(), isTrue);
          result.fold(
            (f) => expect(f, isNull),
            (_) => fail('Expected Left'),
          );
        });
      });
    });
  });
}
