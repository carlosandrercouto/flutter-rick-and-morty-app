import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
      imageUrl: 'https://image',
      originName: 'Earth',
      locationName: 'Earth',
    ),
  ];

  group('HomeState', () {
    // ── States que usam identityHashCode (sem value equality intencional) ──

    group('HomeInitialState', () {
      test('two instances are not equal (identity-based)', () {
        expect(HomeInitialState(), isNot(equals(HomeInitialState())));
      });
    });

    group('LoadingEpsodeState', () {
      test('two instances are not equal (identity-based)', () {
        expect(LoadingEpsodeState(), isNot(equals(LoadingEpsodeState())));
      });
    });

    group('LoadingCharactersState', () {
      test('two instances are not equal (identity-based)', () {
        expect(
          LoadingCharactersState(),
          isNot(equals(LoadingCharactersState())),
        );
      });
    });

    // ── States com value equality ───────────────────────────────────────────

    group('LoadedEpsodeState', () {
      test('supports value equality', () {
        expect(
          LoadedEpsodeState(epsode: tEpsode),
          equals(LoadedEpsodeState(epsode: tEpsode)),
        );
      });

      test('instances with different epsode are not equal', () {
        const other = Epsode(
          id: 99,
          name: 'Other',
          airDate: 'Other',
          epsode: 'S01E01',
          characters: [],
        );

        expect(
          LoadedEpsodeState(epsode: tEpsode),
          isNot(equals(LoadedEpsodeState(epsode: other))),
        );
      });

      test('exposes the correct epsode', () {
        final state = LoadedEpsodeState(epsode: tEpsode);

        expect(state.epsode, tEpsode);
      });
    });

    group('ErrorLoadEpsodeState', () {
      test('supports value equality', () {
        expect(
          ErrorLoadEpsodeState(errorStateType: ErrorStateType.timeout),
          equals(ErrorLoadEpsodeState(errorStateType: ErrorStateType.timeout)),
        );
      });

      test('instances with different errorStateType are not equal', () {
        expect(
          ErrorLoadEpsodeState(errorStateType: ErrorStateType.timeout),
          isNot(equals(
            ErrorLoadEpsodeState(errorStateType: ErrorStateType.genericError),
          )),
        );
      });
    });

    group('LoadedCharactersState', () {
      test('supports value equality', () {
        expect(
          LoadedCharactersState(characters: tCharacters),
          equals(LoadedCharactersState(characters: tCharacters)),
        );
      });

      test('exposes the correct characters list', () {
        final state = LoadedCharactersState(characters: tCharacters);

        expect(state.characters, tCharacters);
        expect(state.characters, hasLength(1));
      });
    });

    group('ErrorLoadCharactersState', () {
      test('supports value equality', () {
        expect(
          ErrorLoadCharactersState(errorStateType: ErrorStateType.timeout),
          equals(
            ErrorLoadCharactersState(errorStateType: ErrorStateType.timeout),
          ),
        );
      });

      test('instances with different errorStateType are not equal', () {
        expect(
          ErrorLoadCharactersState(errorStateType: ErrorStateType.timeout),
          isNot(equals(
            ErrorLoadCharactersState(
              errorStateType: ErrorStateType.genericError,
            ),
          )),
        );
      });
    });
  });
}
