import 'package:equatable/equatable.dart';

import '../../../enums/login_error_type_enum.dart';

/// Entidade de domínio que representa um erro de login.
class LoginErrorData extends Equatable {
  final LoginErrorType errorType;

  const LoginErrorData({
    required this.errorType,
  });

  @override
  List<Object> get props => [errorType];
}
