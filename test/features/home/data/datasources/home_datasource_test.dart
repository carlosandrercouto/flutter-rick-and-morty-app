import 'package:flutter_template/core/enums/api_response_status_enum.dart';
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

  setUp(() {
    mockApiService = MockApiService();
    datasource = HomeDatasource(apiService: mockApiService);
  });

  group('HomeDatasource', () {
    group('getEpsode', () {
      test(
        'should return Epsode when success',
        () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: {
              'id': 28,
              'name': 'The Ricklantis Mixup',
              'air_date': 'September 10, 2017',
              'episode': 'S03E07',
              'characters': ['https://rickandmortyapi.com/api/character/1'],
            },
          );

          final result = await datasource.getEpsode(id: 28);

          expect(mockApiService.lastEndpoint, contains('/episode/28'));
          expect(result.isRight(), isTrue);
        },
      );
    });

    group('getCharacters', () {
      test(
        'should return List of CharacterEntity when success',
        () async {
          mockApiService.result = ApiResponse(
            status: ApiResponseStatus.success,
            result: {
              'data': [
                {
                  'id': 1,
                  'name': 'Rick Sanchez',
                  'status': 'Alive',
                  'species': 'Human',
                  'gender': 'Male',
                  'image': '',
                  'origin': {'name': 'Earth'},
                  'location': {'name': 'Earth'},
                },
              ],
            },
          );

          final result = await datasource.getCharacters(ids: [1]);

          expect(mockApiService.lastEndpoint, contains('/character/1'));
          expect(result.isRight(), isTrue);
        },
      );
    });
  });
}
