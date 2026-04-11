import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/api_response_status_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/core/errors/session_expired_failure.dart';
import 'package:flutter_template/core/services/api_service.dart';
import 'package:flutter_template/core/services/apis/api_endpoints.dart';
import 'package:flutter_template/core/shared/domain/entities/api_response.dart';
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
    test('deve retornar HomeDataEntity quando sucesso com map validos', () async {
      mockApiService.result = ApiResponse(
        status: ApiResponseStatus.success,
        result: {
          'balance': {
            'available': 100.0,
            'incomes': 20.0,
            'expenses': 10.0,
          },
          'transactions': []
        },
      );

      final result = await datasource.getHomeData();

      expect(mockApiService.lastEndpoint, ApiEndpoints.getTransactions.url);
      expect(result.isRight(), isTrue);
    });

    test('deve retornar SessionExpiredFailure quando estatus for errorSessionExpired', () async {
      mockApiService.result = ApiResponse(status: ApiResponseStatus.errorSessionExpired);

      final result = await datasource.getHomeData();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<SessionExpiredFailure>()),
        (r) => fail('Deveria ser Left'),
      );
    });
  });
}
