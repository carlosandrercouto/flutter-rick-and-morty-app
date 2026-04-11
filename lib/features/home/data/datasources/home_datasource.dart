import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/shared/domain/entities/api_response.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_data_model.dart';

/// Datasource da home.
///
/// Arquitetura do Datasource:
/// - Extends o repositório abstrato diretamente
/// - Recebe [ApiService] como dependência injetável no construtor
/// - Cada método: seleciona o endpoint no enum → chama _apiService (ou mock) →
///   trata [ApiResponseStatus] → mapeia com o model
class HomeDatasource extends HomeRepository {
  final ApiService _apiService;

  HomeDatasource({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  @override
  Future<Either<Failure?, HomeDataEntity>> getHomeData() async {
    final ApiEndpoints endpoint = ApiEndpoints.getTransactions;

    final ApiResponse apiResponse = await _apiService(
      endpoint: endpoint.url,
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'HomeDatasource: getHomeData',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final HomeDataEntity resultData = HomeDataModel.fromMap(
          map: apiResponse.result!,
        );

        return Right(resultData);
      } catch (error) {
        log('Error: ${error.toString()}', name: 'HomeDatasource: getHomeData');

        /// TODO: Implementar gravação de log de erro no Crashlytics ou simular
        return const Left(null);
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Left(TimeoutFailure());
    } else if (apiResponse.status == ApiResponseStatus.errorSessionExpired) {
      return Left(SessionExpiredFailure());
    }

    return const Left(null);
  }
}
