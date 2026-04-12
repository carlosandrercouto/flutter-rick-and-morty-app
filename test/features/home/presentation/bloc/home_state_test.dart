import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeState', () {
    const tBalance = BalanceEntity(available: 1, incomes: 1, expenses: 1);
    const tHomeData = HomeDataEntity(balance: tBalance, transactionsList: []);

    group('HomeInitialState', () {
      test('supports value equality (via identityHashCode in base class)', () {
        // By design in our project, some states use identityHashCode to always trigger rebuilds
        final state1 = HomeInitialState();
        final state2 = HomeInitialState();
        expect(state1, isNot(equals(state2)));
      });
    });

    group('LoadingHomeTransactionsState', () {
      test('supports value equality (via identityHashCode in base class)', () {
        final state1 = LoadingHomeTransactionsState();
        final state2 = LoadingHomeTransactionsState();
        expect(state1, isNot(equals(state2)));
      });
    });

    group('LoadedHomeTranactionsState', () {
      test('supports value equality', () {
        expect(
          LoadedHomeTranactionsState(homeData: tHomeData),
          equals(LoadedHomeTranactionsState(homeData: tHomeData)),
        );
      });

      test('props are correct', () {
        expect(
          LoadedHomeTranactionsState(homeData: tHomeData).props,
          equals([tHomeData]),
        );
      });
    });

    group('ErrorLoadHomeTransactionsState', () {
      test('supports value equality', () {
        expect(
          ErrorLoadHomeTransactionsState(errorStateType: ErrorStateType.timeout),
          equals(ErrorLoadHomeTransactionsState(errorStateType: ErrorStateType.timeout)),
        );
      });

      test('props are correct', () {
        expect(
          ErrorLoadHomeTransactionsState(errorStateType: ErrorStateType.timeout).props,
          equals([ErrorStateType.timeout]),
        );
      });
    });
  });
}
