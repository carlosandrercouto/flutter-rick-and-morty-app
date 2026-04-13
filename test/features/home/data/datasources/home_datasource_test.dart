import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/services/api_service.dart';
import 'package:flutter_template/core/entities/api_response.dart';
import 'package:flutter_template/features/home/data/datasources/home_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  late MockApiService mockApiService;
  late HomeDatasource datasource;

  const tEpsodeMap = {
    'id': 28,
    'name': 'The Ricklantis Mixup',
    'air_date': 'September 10, 2017',
    'episode': 'S03E07',
    'characters': ['https://rickandmortyapi.com/api/character/1'],
  };

  const tCharacterMap = {
    'id': 1,
    'name': 'Rick Sanchez',
    'status': 'Alive',
    'species': 'Human',
    'gender': 'Male',
    'image': '',
    'origin': {'name': 'Earth'},
    'location': {'name': 'Earth'},
  };

  setUp(() {
    mockApiService = MockApiService();
    datasource = HomeDatasource(apiService: mockApiService);
  });

  group('HomeDatasource', () {
    group('getEpsode', () {
      test('should build the correct endpoint URL', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: tEpsodeMap,
        );

        await datasource.getEpsode(id: 28);

        expect(mockApiService.lastEndpoint, contains('/episode/28'));
      });

      test('should return Right(Epsode) on success', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: tEpsodeMap,
        );

        final result = await datasource.getEpsode(id: 28);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected Right'),
          (epsode) {
            expect(epsode.id, 28);
            expect(epsode.name, 'The Ricklantis Mixup');
            expect(epsode.characters, [1]);
          },
        );
      });

      test('should return Left(TimeoutFailure) on timeout error', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorTimeout,
        );

        final result = await datasource.getEpsode(id: 28);

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<TimeoutFailure>()),
          (_) => fail('Expected Left'),
        );
      });

      test(
        'should return Left(SessionExpiredFailure) on session expired error',
        () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.errorSessionExpired,
          );

          final result = await datasource.getEpsode(id: 28);

          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<SessionExpiredFailure>()),
            (_) => fail('Expected Left'),
          );
        },
      );

      test('should return Left(null) on generic error status', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorGeneric,
        );

        final result = await datasource.getEpsode(id: 28);

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isNull),
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

    group('getCharacters', () {
      test('should build endpoint with a single ID', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: {'data': [tCharacterMap]},
        );

        await datasource.getCharacters(ids: [1]);

        expect(mockApiService.lastEndpoint, contains('/character/1'));
      });

      test('should build endpoint with multiple IDs joined by comma', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.success,
          result: {'data': <Map<String, dynamic>>[]},
        );

        await datasource.getCharacters(ids: [1, 2, 3]);

        expect(mockApiService.lastEndpoint, contains('1,2,3'));
      });

      test(
        'should return Right(List<CharacterEntity>) on success with data list',
        () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: {
              'data': [tCharacterMap],
            },
          );

          final result = await datasource.getCharacters(ids: [1]);

          expect(result.isRight(), isTrue);
          result.fold(
            (_) => fail('Expected Right'),
            (characters) {
              expect(characters, hasLength(1));
              expect(characters.first.id, 1);
              expect(characters.first.name, 'Rick Sanchez');
            },
          );
        },
      );

      test(
        'should return Right with single character when API returns bare map (1 ID)',
        () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: tCharacterMap,
          );

          final result = await datasource.getCharacters(ids: [1]);

          expect(result.isRight(), isTrue);
          result.fold(
            (_) => fail('Expected Right'),
            (characters) => expect(characters, hasLength(1)),
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
                {...tCharacterMap, 'id': 2, 'name': 'Morty Smith'},
                {...tCharacterMap, 'id': 1, 'name': 'Rick Sanchez'},
                {...tCharacterMap, 'id': 3, 'name': 'Beth Smith'},
              ],
            },
          );

          final result = await datasource.getCharacters(ids: [1, 2, 3]);

          result.fold(
            (_) => fail('Expected Right'),
            (characters) {
              expect(characters[0].name, 'Beth Smith');
              expect(characters[1].name, 'Morty Smith');
              expect(characters[2].name, 'Rick Sanchez');
            },
          );
        },
      );

      test('should return Left(TimeoutFailure) on timeout error', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorTimeout,
        );

        final result = await datasource.getCharacters(ids: [1]);

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<TimeoutFailure>()),
          (_) => fail('Expected Left'),
        );
      });

      test(
        'should return Left(SessionExpiredFailure) on session expired error',
        () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.errorSessionExpired,
          );

          final result = await datasource.getCharacters(ids: [1]);

          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<SessionExpiredFailure>()),
            (_) => fail('Expected Left'),
          );
        },
      );

      test('should return Left(null) on generic error status', () async {
        mockApiService.result = ApiResponse(
          status: ApiResponseStatus.errorGeneric,
        );

        final result = await datasource.getCharacters(ids: [1]);

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isNull),
          (_) => fail('Expected Left'),
        );
      });
    });
  });
}
