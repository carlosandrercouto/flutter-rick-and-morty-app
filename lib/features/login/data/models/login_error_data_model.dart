import '../../../../core/enums/login_error_type_enum.dart';
import '../../../../core/shared/domain/entities/login_error_data.dart';

/// Model de dados de erro de login.
///
/// Faz o parsing do map retornado pela API (ou mock)
/// para a entidade de domínio [LoginErrorData].
///
/// A lógica de mapeamento da string para o enum fica
/// encapsulada dentro de [LoginErrorType.fromString].
class LoginErrorDataModel extends LoginErrorData {
  const LoginErrorDataModel({
    required super.errorType,
  });

  static LoginErrorDataModel fromMap({required Map<String, dynamic> map}) {
    return LoginErrorDataModel(
      errorType: LoginErrorType.fromString(map['error']),
    );
  }
}
