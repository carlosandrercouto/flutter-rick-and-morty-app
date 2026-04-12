import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_login_data.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/login_repository.dart';

/// Caso de uso responsável por realizar o login do usuário.
///
/// Segue o padrão de DTOs: recebe um objeto [PostRequestLoginParams]
/// com os dados necessários e delega ao repositório.
class PostRequestLoginUseCase
    implements UseCase<UserLoginData, PostRequestLoginParams> {
  final LoginRepository repository;

  PostRequestLoginUseCase({required this.repository});

  @override
  Future<Either<Failure?, UserLoginData>> call(PostRequestLoginParams params) {
    return repository.postRequestLogin(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parâmetros necessários para executar o [PostRequestLoginUseCase].
class PostRequestLoginParams {
  final String email;
  final String password;

  PostRequestLoginParams({required this.email, required this.password});
}
