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
    CharacterEntity(
      id: 2,
      name: 'Morty Smith',
      status: 'Alive',
      species: 'Human',
      gender: 'Male',
      imageUrl: 'https://image2',
      originName: 'Earth',
      locationName: 'Earth',
    ),
  ];

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetCharactersUseCase(repository: mockHomeRepository);
  });

  group('GetCharactersUseCase', () {
    test('should return Right(List<CharacterEntity>) when repository succeeds',
        () async {
      mockHomeRepository.result = const Right(tCharacters);

      final result = await useCase(const GetCharactersParams(ids: [1, 2]));

      expect(result, const Right(tCharacters));
    });

    test('should return Left(TimeoutFailure) when repository returns timeout',
        () async {
      mockHomeRepository.result = Left(TimeoutFailure());

      final result = await useCase(const GetCharactersParams(ids: [1]));

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<TimeoutFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test(
      'should return Left(SessionExpiredFailure) when repository returns session expired',
      () async {
        mockHomeRepository.result = Left(SessionExpiredFailure());

        final result = await useCase(const GetCharactersParams(ids: [1]));

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<SessionExpiredFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );

    test('should return Left(null) when repository returns generic failure',
        () async {
      mockHomeRepository.result = const Left(null);

      final result = await useCase(const GetCharactersParams(ids: [1]));

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isNull),
        (_) => fail('Expected Left'),
      );
    });

    group('GetCharactersParams', () {
      test('supports value equality', () {
        expect(
          const GetCharactersParams(ids: [1, 2]),
          const GetCharactersParams(ids: [1, 2]),
        );
      });

      test('instances with different ids are not equal', () {
        expect(
          const GetCharactersParams(ids: [1]),
          isNot(const GetCharactersParams(ids: [2])),
        );
      });
    });
  });
}
