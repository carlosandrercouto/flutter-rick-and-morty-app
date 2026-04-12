import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/error_state_type_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../../../core/helpers/session_helper.dart';

import '../../data/datasources/login_datasource.dart';
import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/usecases/usecases_export.dart';

part 'login_event.dart';
part 'login_state.dart';

/// BLoC responsável pelo gerenciamento de estado da tela de login.
///
/// Segue o padrão do ecossistema BLoC:
/// - Recebe [LoginRepository] como dependência injetada
/// - Mapeia eventos para estados usando handlers privados
/// - Utiliza [PostRequestLoginUseCase] para executar a lógica de negócio
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  final SessionHelper _sessionHelper;

  LoginBloc({LoginRepository? loginRepository, SessionHelper? sessionHelper})
    : _loginRepository = loginRepository ?? LoginDatasource(),
      _sessionHelper = sessionHelper ?? SessionHelper.instance,
      super(LoginInitialState()) {
    on<RequestLoginEvent>(_onRequestLogin);
    on<ResetLoginEvent>(_onResetLogin);
  }

  /// Handler para submissão do formulário de login.
  Future<void> _onRequestLogin(
    RequestLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(RequestingLoginState());

    /// TODO: Adicionar verificação de device offline

    final postRequestLoginUseCase = PostRequestLoginUseCase(
      repository: _loginRepository,
    );

    final postRequestLogin = await postRequestLoginUseCase(
      PostRequestLoginParams(email: event.email, password: event.password),
    );

    postRequestLogin.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(
            ErrorRequestLoginState(
              errorStateMessage: ErrorStateType.timeout.message,
            ),
          );
        } else if (failure is SessionExpiredFailure) {
          emit(
            ErrorRequestLoginState(
              errorStateMessage: ErrorStateType.sessionExpired.message,
            ),
          );
        } else {
          emit(
            ErrorRequestLoginState(
              errorStateMessage: ErrorStateType.genericError.message,
            ),
          );
        }
      },
      (UserLoginData data) {
        if (data.error != null) {
          emit(
            ErrorRequestLoginState(
              errorStateMessage: data.error!.errorType.apiMessage,
            ),
          );
        } else {
          _sessionHelper.initUserLoginData(userLoginData: data);
          emit(RequestedLoginState(user: data));
        }
      },
    );
  }

  /// Handler para resetar o estado do BLoC ao estado inicial.
  Future<void> _onResetLogin(
    ResetLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInitialState());
  }
}
