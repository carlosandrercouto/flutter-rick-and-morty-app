import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_template/features/home/domain/usecases/get_characters_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure?, List<CharacterEntity>>? result;

  @override
  Future<Either<Failure?, Epsode>> getEpsode({required int id}) async {
    return const Left(null);
  }

  @override
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  }) async {
    return result ?? const Left(null);
  }
}

void main() {
  late MockHomeRepository mockHomeRepository;
  late GetCharactersUseCase useCase;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetCharactersUseCase(repository: mockHomeRepository);
  });

  const tCharacters = [
    CharacterEntity(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      gender: 'Male',
      imageUrl: 'https://image',
      originName: 'Earth',
      locationName: 'Earth',
    ),
  ];

  test('should get characters from repository', () async {
    mockHomeRepository.result = const Right(tCharacters);

    final result = await useCase(const GetCharactersParams(ids: [1]));

    expect(result, const Right(tCharacters));
  });

  test('should return failure when repository fails', () async {
    mockHomeRepository.result = Left(TimeoutFailure());

    final result = await useCase(const GetCharactersParams(ids: [1]));

    expect(result, Left(TimeoutFailure()));
  });
}
