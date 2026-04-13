import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_template/features/home/domain/usecases/get_epsode_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure?, Epsode>? result;

  @override
  Future<Either<Failure?, Epsode>> getEpsode({required int id}) async {
    return result ?? const Left(null);
  }

  @override
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  }) async {
    return const Left(null);
  }
}

void main() {
  late MockHomeRepository mockHomeRepository;
  late GetEpsodeUseCase useCase;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetEpsodeUseCase(repository: mockHomeRepository);
  });

  const tEpsode = Epsode(
    id: 1,
    name: 'Test',
    airDate: 'Test',
    epsode: 'Test',
    characters: [1],
  );

  test('should get epsode from repository', () async {
    mockHomeRepository.result = const Right(tEpsode);

    final result = await useCase(const GetEpsodeParams(id: 1));

    expect(result, const Right(tEpsode));
  });

  test('should return failure when repository fails', () async {
    mockHomeRepository.result = Left(TimeoutFailure());

    final result = await useCase(const GetEpsodeParams(id: 1));

    expect(result, Left(TimeoutFailure()));
  });
}
