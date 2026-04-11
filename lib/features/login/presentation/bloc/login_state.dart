part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [identityHashCode(this)];
}

/// Estado inicial do BLoC — formulário pronto para interação.
class LoginInitialState extends LoginState {}

/// Estado emitido enquanto a requisição de login está em progresso.
class LoginLoadingState extends LoginState {}

/// Estado emitido quando o login é realizado com sucesso.
class LoginSuccessState extends LoginState {
  final UserLoginData user;

  const LoginSuccessState({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado emitido quando ocorre um erro durante o login.
class LoginErrorState extends LoginState {
  final String message;

  const LoginErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
