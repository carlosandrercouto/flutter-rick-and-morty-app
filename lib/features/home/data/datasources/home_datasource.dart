import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/entities/api_response.dart';

import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/models_export.dart';

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
  Future<Either<Failure?, HomeDataEntity>> getHomeTransactonsData() async {
    final ApiEndpoints endpoint = ApiEndpoints.getTransactions;

    final ApiResponse apiResponse = await _apiService(
      endpoint: endpoint.url,
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'HomeDatasource: getHomeTransactonsData',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final HomeDataEntity resultData = HomeDataModel.fromMap(
          map: apiResponse.result!,
        );

        return Right(resultData);
      } catch (error) {
        log(
          'Error: ${error.toString()}',
          name: 'HomeDatasource: getHomeTransactonsData',
        );

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

  @override
  Future<Either<Failure?, Epsode>> getEpsode({required int id}) async {
    final ApiEndpoints endpoint = ApiEndpoints.getEpsodios;

    final ApiResponse apiResponse = await _apiService(
      endpoint: '${endpoint.url}/$id',
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'HomeDatasource: getEpsode',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final Epsode resultData = EpsodeModel.fromMap(
          map: apiResponse.result!,
        );

        return Right(resultData);
      } catch (error) {
        log(
          'Error: ${error.toString()}',
          name: 'HomeDatasource: getEpsode',
        );

        return const Left(null);
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Left(TimeoutFailure());
    } else if (apiResponse.status == ApiResponseStatus.errorSessionExpired) {
      return Left(SessionExpiredFailure());
    }

    return const Left(null);
  }

  @override
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  }) async {
    final ApiEndpoints endpoint = ApiEndpoints.getCharacters;
    // A API aceita múltiplos IDs: /character/1,2,3
    final idsParam = ids.join(',');

    final ApiResponse apiResponse = await _apiService(
      endpoint: '${endpoint.url}/$idsParam',
      request: ApiRequest(requestType: endpoint.requestType, body: {}),
      devLog: 'HomeDatasource: getCharacters',
      currentStackTrace: StackTrace.current,
    );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final result = apiResponse.result!;

        // Quando a API retorna um array, o ApiService envolve em {'data': [...]}
        // Quando retorna um único objeto, retorna diretamente como Map
        final List<dynamic> rawList = result.containsKey('data')
            ? result['data'] as List<dynamic>
            : [result];

        final List<CharacterEntity> characters = rawList
            .map((item) => CharacterModel.fromMap(
                  map: item as Map<String, dynamic>,
                ))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        return Right(characters);
      } catch (error) {
        log(
          'Error: ${error.toString()}',
          name: 'HomeDatasource: getCharacters',
        );

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

