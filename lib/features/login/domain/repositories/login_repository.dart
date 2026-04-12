import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_login_data.dart';

/// Contrato do repositório de login.
///
/// Define as operações disponíveis relacionadas à autenticação.
/// A implementação concreta (datasource) está em `data/datasources/`.
abstract class LoginRepository {
  /// Realiza o login com email/usuário e senha.
  Future<Either<Failure?, UserLoginData>> postRequestLogin({
    required String email,
    required String password,
  });
}
