import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/errors/failure.dart';
import 'package:flutter_template/core/usecases/usecase.dart';
import 'package:flutter_template/features/home/domain/entities/balance_entity.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_template/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure?, HomeDataEntity>? result;

  @override
  Future<Either<Failure?, HomeDataEntity>> getHomeData() async {
    return result ?? const Left(null);
  }
}

void main() {
  late MockHomeRepository mockRepository;
  late GetHomeDataUseCase usecase;

  setUp(() {
    mockRepository = MockHomeRepository();
    usecase = GetHomeDataUseCase(repository: mockRepository);
  });

  test('deve obter os dados de home a partir do repositorio de maneira correta', () async {
    const tBalance = BalanceEntity(available: 100, incomes: 200, expenses: 100);
    const tHomeData = HomeDataEntity(balance: tBalance, transactions: []);
    mockRepository.result = const Right(tHomeData);

    final result = await usecase(NoParams());

    expect(result, const Right(tHomeData));
  });
}
