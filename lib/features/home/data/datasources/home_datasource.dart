import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/helpers/environment_helper.dart';
import '../../../../core/helpers/mock_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/shared/domain/entities/api_response.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_data_model.dart';

/// Datasource da feature Home.
///
/// Segue o padrão do projeto:
/// - Estende o repositório abstrato [HomeRepository] diretamente
/// - Alterna entre mock e API real via [EnvironmentHelper.instance.useMock]
/// - Dados mockados centralizados em [MockHelper]
class HomeDatasource extends HomeRepository {
  final ApiService _apiService;

  HomeDatasource({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<Either<Failure?, HomeDataEntity>> getHomeData() async {
    final ApiEndpoints endpoint = ApiEndpoints.getTransactions;

    final ApiResponse apiResponse = EnvironmentHelper.instance.useMock
        ? await MockHelper.instance.call(
            endpoint: endpoint.url,
          )
        : await _apiService(
            endpoint: endpoint.url,
            request: ApiRequest(requestType: endpoint.requestType, body: {}),
            devLog: 'HomeDatasource: getHomeData',
            currentStackTrace: StackTrace.current,
          );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final HomeDataEntity homeData =
            HomeDataModel.fromMap(map: apiResponse.result!);

        return Right(homeData);
      } catch (error) {
        log('Error: ${error.toString()}', name: 'HomeDatasource: getHomeData');
        return const Left(null);
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Left(TimeoutFailure());
    }

    return const Left(null);
  }
}
