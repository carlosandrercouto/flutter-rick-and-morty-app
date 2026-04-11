import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/timeout_failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_data_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC responsável pelo gerenciamento de estado da Home.
///
/// Orquestra o carregamento das transações e expõe os estados
/// correspondentes para a camada de apresentação.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.homeRepository}) : super(HomeInitialState()) {
    on<HomeLoadTransactionsEvent>(_onLoadTransactions);
  }

  final HomeRepository homeRepository;

  /// Carrega os dados da tela Home.
  Future<void> _onLoadTransactions(
    HomeLoadTransactionsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());

    final useCase = GetHomeDataUseCase(repository: homeRepository);
    final result = await useCase(NoParams());

    result.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(HomeErrorTimeoutState());
        } else {
          emit(HomeErrorState(message: 'Não foi possível carregar os dados.'));
        }
      },
      (homeData) => emit(HomeLoadedState(homeData: homeData)),
    );
  }
}
