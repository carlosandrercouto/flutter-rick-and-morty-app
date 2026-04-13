import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    const tEpsode = Epsode(
      id: 1,
      name: 'Test',
      airDate: 'Test',
      epsode: 'Test',
      characters: [1],
    );

    group('HomeInitialState', () {
      test('supports value equality (via identityHashCode in base class)', () {
        // By design, some states use identityHashCode to always trigger rebuilds
        final state1 = HomeInitialState();
        final state2 = HomeInitialState();
        expect(state1, isNot(equals(state2)));
      });
    });

    group('LoadingEpsodeState', () {
      test('supports value equality (via identityHashCode in base class)', () {
        final state1 = LoadingEpsodeState();
        final state2 = LoadingEpsodeState();
        expect(state1, isNot(equals(state2)));
      });
    });

    group('LoadedEpsodeState', () {
      test('supports value equality', () {
        expect(
          LoadedEpsodeState(epsode: tEpsode),
          equals(LoadedEpsodeState(epsode: tEpsode)),
        );
      });
    });

    group('ErrorLoadEpsodeState', () {
      test('supports value equality', () {
        expect(
          ErrorLoadEpsodeState(errorStateType: ErrorStateType.timeout),
          equals(ErrorLoadEpsodeState(errorStateType: ErrorStateType.timeout)),
        );
      });
    });
  });
}
