import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/errors/failure.dart';
import 'package:flutter_template/core/shared/domain/entities/user_login_data.dart';
import 'package:flutter_template/features/login/domain/repositories/login_repository.dart';
import 'package:flutter_template/features/login/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoginRepository implements LoginRepository {
  Either<Failure?, UserLoginData>? result;
  String? lastEmail;
  String? lastPassword;

  @override
  Future<Either<Failure?, UserLoginData>> login({required String email, required String password}) async {
    lastEmail = email;
    lastPassword = password;
    return result ?? const Left(null);
  }
}

void main() {
  late MockLoginRepository mockRepository;
  late LoginUseCase usecase;

  setUp(() {
    mockRepository = MockLoginRepository();
    usecase = LoginUseCase(repository: mockRepository);
  });

  test('deve chamar o repositório com email e password corretos', () async {
    const tUserLoginData = UserLoginData(token: 'token', userId: 'id', name: 'Name', email: 'email@test.com');
    mockRepository.result = const Right(tUserLoginData);

    final result = await usecase(LoginParams(email: 'test@exam.com', password: 'password'));

    expect(result, const Right(tUserLoginData));
    expect(mockRepository.lastEmail, 'test@exam.com');
    expect(mockRepository.lastPassword, 'password');
  });
}
