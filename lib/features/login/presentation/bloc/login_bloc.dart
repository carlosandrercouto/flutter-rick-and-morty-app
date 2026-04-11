import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/timeout_failure.dart';
import '../../../../core/shared/domain/entities/user_login_data.dart';
import '../../domain/repositories/login_repository.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

/// BLoC responsável pelo gerenciamento de estado da tela de login.
///
/// Segue o padrão do monetizze:
/// - Recebe [LoginRepository] como dependência injetada
/// - Mapeia eventos para estados usando handlers privados
/// - Utiliza [LoginUseCase] para executar a lógica de negócio
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LoginResetEvent>(_onLoginReset);
  }

  /// Handler para submissão do formulário de login.
  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoadingState());

    final useCase = LoginUseCase(repository: loginRepository);

    final result = await useCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(LoginErrorState(message: 'Tempo limite excedido. Verifique sua conexão.'));
        } else {
          emit(LoginErrorState(message: 'Ocorreu um erro inesperado.'));
        }
      },
      (UserLoginData data) {
        if (data.error != null) {
          emit(LoginErrorState(message: 'Usuário ou senha inválidos.'));
        } else {
          emit(LoginSuccessState(user: data));
        }
      },
    );
  }

  /// Handler para resetar o estado do BLoC ao estado inicial.
  Future<void> _onLoginReset(
    LoginResetEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInitialState());
  }
}
