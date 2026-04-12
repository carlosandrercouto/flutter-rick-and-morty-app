part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [identityHashCode(this)];
}

/// Estado inicial do BLoC — formulário pronto para interação.
class LoginInitialState extends LoginState {}

// Relacionado ao evento RequestLoginEvent
// =====================================================================================================================

class RequestingLoginState extends LoginState {}

class RequestedLoginState extends LoginState {
  final UserLoginData user;

  const RequestedLoginState({required this.user});

  @override
  List<Object?> get props => [user];
}

class ErrorRequestLoginState extends LoginState {
  final String errorStateMessage;

  const ErrorRequestLoginState({required this.errorStateMessage});

  @override
  List<Object?> get props => [errorStateMessage];
}
