part of 'home_bloc.dart';

/// Evento base da feature Home.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Dispara o carregamento das transações.
class HomeLoadTransactionsEvent extends HomeEvent {
  const HomeLoadTransactionsEvent();
}
