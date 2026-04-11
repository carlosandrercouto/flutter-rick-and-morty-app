part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

/// Evento disparado quando o usuário submete o formulário de login.
class LoginSubmittedEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmittedEvent({
    required this.email,
    required this.password,
  });
}

/// Evento para resetar o estado do BLoC ao [LoginInitialState].
class LoginResetEvent extends LoginEvent {
  const LoginResetEvent();
}
