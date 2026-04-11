import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/enums/api_response_status_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/helpers/environment_helper.dart';
import '../../../../core/helpers/mock_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/apis/api_endpoints.dart';
import '../../../../core/shared/domain/entities/api_response.dart';
import '../../../../core/shared/domain/entities/user_login_data.dart';
import '../../domain/repositories/login_repository.dart';
import '../models/user_login_data_model.dart';

/// Datasource de login.
///
/// Segue o padrão do [WithdrawDatasource] do monetizze:
/// - Extends o repositório abstrato diretamente
/// - Recebe [ApiService] como dependência injetável no construtor
/// - Cada método: seleciona o endpoint no enum → chama _apiService (ou mock) →
///   trata [ApiResponseStatus] → mapeia com o model
///
/// O controle entre mock e API real é feito via [EnvironmentHelper.instance.useMock],
/// configurado no arquivo `.env` (USE_MOCK=true|false).
/// Os dados mockados estão centralizados em [MockHelper].
class LoginDatasource extends LoginRepository {
  final ApiService _apiService;

  LoginDatasource({
    ApiService? apiService,
  }) : _apiService = apiService ?? ApiService();

  @override
  Future<Either<Failure?, UserLoginData>> login({
    required String email,
    required String password,
  }) async {
    final ApiEndpoints endpoint = ApiEndpoints.postLogin;

    final ApiResponse apiResponse = EnvironmentHelper.instance.useMock
        ? await MockHelper.instance.call(
            endpoint: endpoint.url,
            body: {'email': email, 'password': password},
          )
        : await _apiService(
            endpoint: endpoint.url,
            request: ApiRequest(
              requestType: endpoint.requestType,
              body: {'email': email, 'password': password},
            ),
            devLog: 'LoginDatasource: login',
            currentStackTrace: StackTrace.current,
          );

    if (apiResponse.status == ApiResponseStatus.success) {
      try {
        final UserLoginData result = UserLoginDataModel.fromMap(
          map: apiResponse.result!,
        );
        return Future.value(Right(result));
      } catch (error) {
        log('Error: ${error.toString()}', name: 'LoginDatasource: login');
        return Future.value(const Left(null));
      }
    } else if (apiResponse.status == ApiResponseStatus.errorTimeout) {
      return Future.value(Left(TimeoutFailure()));
    }

    return Future.value(const Left(null));
  }
}
