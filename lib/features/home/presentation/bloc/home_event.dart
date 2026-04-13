part of 'home_bloc.dart';

/// Evento base da feature Home.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Dispara o carregamento das transações.
class LoadHomeTransactionsEvent extends HomeEvent {
  const LoadHomeTransactionsEvent();
}

/// Dispara o carregamento de um episódio pelo seu [id].
class LoadEpsodeEvent extends HomeEvent {
  const LoadEpsodeEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Dispara o carregamento dos personagens pelos seus [ids].
class LoadCharactersEvent extends HomeEvent {
  const LoadCharactersEvent({required this.ids});

  final List<int> ids;

  @override
  List<Object?> get props => [ids];
}
