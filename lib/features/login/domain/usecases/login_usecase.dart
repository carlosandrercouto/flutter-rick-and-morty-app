import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/shared/domain/entities/user_login_data.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/login_repository.dart';

/// Caso de uso responsável por realizar o login do usuário.
///
/// Segue o padrão do monetizze: recebe um objeto [LoginParams]
/// com os dados necessários e delega ao repositório.
class LoginUseCase implements UseCase<UserLoginData, LoginParams> {
  final LoginRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure?, UserLoginData>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parâmetros necessários para executar o [LoginUseCase].
class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
