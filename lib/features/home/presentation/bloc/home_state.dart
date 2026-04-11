part of 'home_bloc.dart';

/// Estado base da feature Home.
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

/// Estado inicial — antes de qualquer carregamento.
class HomeInitialState extends HomeState {}

/// Estado de carregamento das transações.
class HomeLoadingState extends HomeState {}

/// Estado de sucesso com os dados da home (saldo e transações) carregados.
class HomeLoadedState extends HomeState {
  HomeLoadedState({required this.homeData});

  final HomeDataEntity homeData;

  @override
  List<Object?> get props => [homeData];
}

/// Estado de erro genérico.
class HomeErrorState extends HomeState {
  HomeErrorState({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Estado de erro por timeout.
class HomeErrorTimeoutState extends HomeState {}

/// Estado de erro de sessão expirada.
class HomeErrorUserSessionState extends HomeState {}
