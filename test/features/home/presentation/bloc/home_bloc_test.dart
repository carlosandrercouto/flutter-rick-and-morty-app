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
  });

  group('HomeBloc', () {
    test('initial state is HomeInitialState', () {
      final bloc = HomeBloc(homeRepository: mockHomeRepository);
      expect(bloc.state, isA<HomeInitialState>());
      bloc.close();
    });

    // ── LoadEpsodeEvent ─────────────────────────────────────────────────────

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
          isA<LoadedEpsodeState>().having(
            (s) => s.epsode,
            'epsode',
            tEpsode,
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingEpsodeState, ErrorLoadEpsodeState(timeout)] on TimeoutFailure',
        build: () {
          mockHomeRepository.epsodeResult = Left(TimeoutFailure());
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadEpsodeEvent(id: 28)),
        expect: () => [
          isA<LoadingEpsodeState>(),
          isA<ErrorLoadEpsodeState>().having(
            (s) => s.errorStateType,
            'errorStateType',
            ErrorStateType.timeout,
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingEpsodeState, ErrorLoadEpsodeState(sessionExpired)] on SessionExpiredFailure',
        build: () {
          mockHomeRepository.epsodeResult = Left(SessionExpiredFailure());
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadEpsodeEvent(id: 28)),
        expect: () => [
          isA<LoadingEpsodeState>(),
          isA<ErrorLoadEpsodeState>().having(
            (s) => s.errorStateType,
            'errorStateType',
            ErrorStateType.sessionExpired,
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingEpsodeState, ErrorLoadEpsodeState(genericError)] on generic failure',
        build: () {
          mockHomeRepository.epsodeResult = const Left(null);
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadEpsodeEvent(id: 28)),
        expect: () => [
          isA<LoadingEpsodeState>(),
          isA<ErrorLoadEpsodeState>().having(
            (s) => s.errorStateType,
            'errorStateType',
            ErrorStateType.genericError,
          ),
        ],
      );
    });

    // ── LoadCharactersEvent ─────────────────────────────────────────────────

    group('LoadCharactersEvent', () {
      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingCharactersState, LoadedCharactersState] on success',
        build: () {
          mockHomeRepository.charactersResult = const Right(tCharacters);
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadCharactersEvent(ids: [1, 2])),
        expect: () => [
          isA<LoadingCharactersState>(),
          isA<LoadedCharactersState>().having(
            (s) => s.characters,
            'characters',
            tCharacters,
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingCharactersState, ErrorLoadCharactersState(timeout)] on TimeoutFailure',
        build: () {
          mockHomeRepository.charactersResult = Left(TimeoutFailure());
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadCharactersEvent(ids: [1])),
        expect: () => [
          isA<LoadingCharactersState>(),
          isA<ErrorLoadCharactersState>().having(
            (s) => s.errorStateType,
            'errorStateType',
            ErrorStateType.timeout,
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingCharactersState, ErrorLoadCharactersState(sessionExpired)] on SessionExpiredFailure',
        build: () {
          mockHomeRepository.charactersResult = Left(SessionExpiredFailure());
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadCharactersEvent(ids: [1])),
        expect: () => [
          isA<LoadingCharactersState>(),
          isA<ErrorLoadCharactersState>().having(
            (s) => s.errorStateType,
            'errorStateType',
            ErrorStateType.sessionExpired,
          ),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'should emit [LoadingCharactersState, ErrorLoadCharactersState(genericError)] on generic failure',
        build: () {
          mockHomeRepository.charactersResult = const Left(null);
          return HomeBloc(homeRepository: mockHomeRepository);
        },
        act: (bloc) => bloc.add(const LoadCharactersEvent(ids: [1])),
        expect: () => [
          isA<LoadingCharactersState>(),
          isA<ErrorLoadCharactersState>().having(
            (s) => s.errorStateType,
            'errorStateType',
            ErrorStateType.genericError,
          ),
        ],
      );
    });
  });
}
