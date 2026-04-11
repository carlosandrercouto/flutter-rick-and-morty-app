import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/services/api_service.dart';
import 'package:flutter_template/core/services/apis/api_endpoints.dart';
import 'package:flutter_template/core/shared/domain/entities/api_response.dart';
import 'package:flutter_template/features/login/data/datasources/login_datasource.dart';
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
  late LoginDatasource datasource;

  setUp(() {
    mockApiService = MockApiService();
    datasource = LoginDatasource(apiService: mockApiService);
  });

  group('LoginDatasource', () {
    test('deve retornar UserLoginData se a API retornar success', () async {
      mockApiService.result = ApiResponse(
        status: ApiResponseStatus.success,
        result: {
          'token': 'abc',
          'userId': '123',
          'name': 'Name',
          'email': 'email@test.com'
        },
      );

      final result = await datasource.login(email: 'email@test.com', password: '123');

      expect(mockApiService.lastEndpoint, ApiEndpoints.postLogin.url);
      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Deveria ser Right'),
        (r) {
          expect(r.token, 'abc');
        },
      );
    });

    test('deve retornar TimeoutFailure se a API retornar errorTimeout', () async {
      mockApiService.result = ApiResponse(status: ApiResponseStatus.errorTimeout);

      final result = await datasource.login(email: 'email', password: '123');

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<TimeoutFailure>()),
        (r) => fail('Deveria ser Left'),
      );
    });
  });
}
