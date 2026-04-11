import '../../../../core/shared/domain/entities/user_login_data.dart';
import 'login_error_data_model.dart';

/// Model de dados do usuário após login.
///
/// Segue o padrão do monetizze (ex: MyProductsProductItemModel):
/// construtor privado [_internal] com super nos parâmetros +
/// factory [fromMap] responsável pelo parsing do map da API.
class UserLoginDataModel extends UserLoginData {
  const UserLoginDataModel._internal({
    required super.token,
    required super.userId,
    required super.name,
    required super.email,
    super.error,
  }) : super();

  factory UserLoginDataModel.fromMap({required Map<String, dynamic> map}) {
    return UserLoginDataModel._internal(
      token: map['token'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      error: map['error'] != null ? LoginErrorDataModel.fromMap(map: map) : null,
    );
  }
}
