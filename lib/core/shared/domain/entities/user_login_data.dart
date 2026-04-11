import 'package:equatable/equatable.dart';

import 'login_error_data.dart';

/// Entidade de domínio que representa os dados do usuário após login bem-sucedido.
class UserLoginData extends Equatable {
  final String token;
  final String userId;
  final String name;
  final String email;
  final LoginErrorData? error;

  const UserLoginData({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
    this.error,
  });

  factory UserLoginData.empty() => const UserLoginData(
        token: '',
        userId: '',
        name: '',
        email: '',
        error: null,
      );

  bool get isAuthenticated => token.isNotEmpty && userId.isNotEmpty;

  UserLoginData copyWith({
    String? token,
    String? userId,
    String? name,
    String? email,
    LoginErrorData? error,
  }) {
    return UserLoginData(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [token, userId, name, email, error];
}
