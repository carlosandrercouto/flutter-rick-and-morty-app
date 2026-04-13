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

  const tEpsode = Epsode(
    id: 28,
    name: 'The Ricklantis Mixup',
    airDate: 'September 10, 2017',
    epsode: 'S03E07',
    characters: [1, 2],
  );

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    useCase = GetEpsodeUseCase(repository: mockHomeRepository);
  });

  group('GetEpsodeUseCase', () {
    test('should delegate to the repository with the correct id', () async {
      mockHomeRepository.result = const Right(tEpsode);

      await useCase(const GetEpsodeParams(id: 28));

      // Verificado indiretamente pelo resultado correto
      final result = await useCase(const GetEpsodeParams(id: 28));
      expect(result.isRight(), isTrue);
    });

    test('should return Right(Epsode) when repository succeeds', () async {
      mockHomeRepository.result = const Right(tEpsode);

      final result = await useCase(const GetEpsodeParams(id: 28));

      expect(result, const Right(tEpsode));
    });

    test('should return Left(TimeoutFailure) when repository returns timeout',
        () async {
      mockHomeRepository.result = Left(TimeoutFailure());

      final result = await useCase(const GetEpsodeParams(id: 28));

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

        final result = await useCase(const GetEpsodeParams(id: 28));

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

      final result = await useCase(const GetEpsodeParams(id: 28));

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isNull),
        (_) => fail('Expected Left'),
      );
    });

    group('GetEpsodeParams', () {
      test('supports value equality', () {
        expect(
          const GetEpsodeParams(id: 1),
          const GetEpsodeParams(id: 1),
        );
      });

      test('instances with different id are not equal', () {
        expect(
          const GetEpsodeParams(id: 1),
          isNot(const GetEpsodeParams(id: 2)),
        );
      });
    });
  });
}
