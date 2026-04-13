import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure?, Epsode>? epsodeResult;
  Either<Failure?, List<CharacterEntity>>? charactersResult;

  @override
  Future<Either<Failure?, Epsode>> getEpsode({required int id}) async {
    return epsodeResult ?? const Left(null);
  }

  @override
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  }) async {
    return charactersResult ?? const Left(null);
  }
}

void main() {
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
  });

  group('HomeBloc', () {
    const tEpsode = Epsode(
      id: 28,
      name: 'The Ricklantis Mixup',
      airDate: 'September 10, 2017',
      epsode: 'S03E07',
      characters: [1, 2],
    );

    const tCharacters = [
      CharacterEntity(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        gender: 'Male',
        imageUrl: 'https://image1',
        originName: 'Earth',
        locationName: 'Earth',
      ),
    ];

    test('initial state is HomeInitialState', () {
      final bloc = HomeBloc(homeRepository: mockHomeRepository);
      expect(bloc.state, isA<HomeInitialState>());
      bloc.close();
    });

    group('LoadEpsodeEvent', () {
      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingEpsodeState, LoadedEpsodeState] on success',
        build: () {
          mockHomeRepository.epsodeResult = const Right(tEpsode);
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadEpsodeEvent(id: 28)),
        expect: () => [
          isA<LoadingEpsodeState>(),
          isA<LoadedEpsodeState>().having((state) => state.epsode, 'epsode', tEpsode),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingEpsodeState, ErrorLoadEpsodeState] on TimeoutFailure',
        build: () {
          mockHomeRepository.epsodeResult = Left(TimeoutFailure());
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadEpsodeEvent(id: 28)),
        expect: () => [
          isA<LoadingEpsodeState>(),
          isA<ErrorLoadEpsodeState>().having(
            (state) => state.errorStateType,
            'errorStateType',
            ErrorStateType.timeout,
          ),
        ],
      );
    });

    group('LoadCharactersEvent', () {
      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingCharactersState, LoadedCharactersState] on success',
        build: () {
          mockHomeRepository.charactersResult = const Right(tCharacters);
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadCharactersEvent(ids: [1])),
        expect: () => [
          isA<LoadingCharactersState>(),
          isA<LoadedCharactersState>().having(
            (state) => state.characters,
            'characters',
            tCharacters,
          ),
        ],
      );
    });
  });
}
