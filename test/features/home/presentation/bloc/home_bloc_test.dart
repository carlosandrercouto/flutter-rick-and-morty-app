import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_template/core/enums/error_state_type_enum.dart';
import 'package:flutter_template/core/errors/errors_export.dart';
import 'package:flutter_template/features/home/domain/entities/entities_export.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHomeRepository implements HomeRepository {
  Either<Failure?, HomeDataEntity>? result;

  @override
  Future<Either<Failure?, HomeDataEntity>> getHomeTransactonsData() async {
    return result ?? const Left(null);
  }
}

void main() {
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
  });

  group('HomeBloc', () {
    const tBalance = BalanceEntity(available: 1000, incomes: 500, expenses: 200);
    const tHomeData = HomeDataEntity(balance: tBalance, transactionsList: []);

    test('initial state is HomeInitialState', () {
      final bloc = HomeBloc(homeRepository: mockHomeRepository);
      expect(bloc.state, isA<HomeInitialState>());
      bloc.close();
    });

    blocTest<HomeBloc, HomeState>(
      'should emit [LoadingHomeTransactionsState, LoadedHomeTranactionsState] on success',
      build: () {
        mockHomeRepository.result = const Right(tHomeData);
        return HomeBloc(homeRepository: mockHomeRepository);
      },
      act: (bloc) => bloc.add(const LoadHomeTransactionsEvent()),
      expect: () => [
        isA<LoadingHomeTransactionsState>(),
        isA<LoadedHomeTranactionsState>().having((state) => state.homeData, 'homeData', tHomeData),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [LoadingHomeTransactionsState, ErrorLoadHomeTransactionsState] on TimeoutFailure',
      build: () {
        mockHomeRepository.result = Left(TimeoutFailure());
        return HomeBloc(homeRepository: mockHomeRepository);
      },
      act: (bloc) => bloc.add(const LoadHomeTransactionsEvent()),
      expect: () => [
        isA<LoadingHomeTransactionsState>(),
        isA<ErrorLoadHomeTransactionsState>().having(
          (state) => state.errorStateType,
          'errorStateType',
          ErrorStateType.timeout,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [LoadingHomeTransactionsState, ErrorLoadHomeTransactionsState] on SessionExpiredFailure',
      build: () {
        mockHomeRepository.result = Left(SessionExpiredFailure());
        return HomeBloc(homeRepository: mockHomeRepository);
      },
      act: (bloc) => bloc.add(const LoadHomeTransactionsEvent()),
      expect: () => [
        isA<LoadingHomeTransactionsState>(),
        isA<ErrorLoadHomeTransactionsState>().having(
          (state) => state.errorStateType,
          'errorStateType',
          ErrorStateType.sessionExpired,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [LoadingHomeTransactionsState, ErrorLoadHomeTransactionsState] on generic failure',
      build: () {
        mockHomeRepository.result = const Left(null);
        return HomeBloc(homeRepository: mockHomeRepository);
      },
      act: (bloc) => bloc.add(const LoadHomeTransactionsEvent()),
      expect: () => [
        isA<LoadingHomeTransactionsState>(),
        isA<ErrorLoadHomeTransactionsState>().having(
          (state) => state.errorStateType,
          'errorStateType',
          ErrorStateType.genericError,
        ),
      ],
    );
  });
}
