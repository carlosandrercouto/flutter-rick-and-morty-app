part of 'home_bloc.dart';

/// Estado base da feature Home.
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [identityHashCode(this)];
}

/// Estado inicial — antes de qualquer carregamento.
class HomeInitialState extends HomeState {}

// Relacionado ao evento LoadHomeTransactionsEvent
// =====================================================================================================================
class LoadingHomeTransactionsState extends HomeState {}

class LoadedHomeTranactionsState extends HomeState {
  LoadedHomeTranactionsState({required this.homeData});

  final HomeDataEntity homeData;

  @override
  List<Object?> get props => [homeData];
}

class ErrorLoadHomeTransactionsState extends HomeState {
  ErrorLoadHomeTransactionsState({required this.errorStateType});

  final ErrorStateType errorStateType;

  @override
  List<Object?> get props => [errorStateType];
}

// Relacionado ao evento LoadEpsodeEvent
// =====================================================================================================================
class LoadingEpsodeState extends HomeState {}

class LoadedEpsodeState extends HomeState {
  LoadedEpsodeState({required this.epsode});

  final Epsode epsode;

  @override
  List<Object?> get props => [epsode];
}

class ErrorLoadEpsodeState extends HomeState {
  ErrorLoadEpsodeState({required this.errorStateType});

  final ErrorStateType errorStateType;

  @override
  List<Object?> get props => [errorStateType];
}

// Relacionado ao evento LoadCharactersEvent
// =====================================================================================================================
class LoadingCharactersState extends HomeState {}

class LoadedCharactersState extends HomeState {
  LoadedCharactersState({required this.characters});

  final List<CharacterEntity> characters;

  @override
  List<Object?> get props => [characters];
}

class ErrorLoadCharactersState extends HomeState {
  ErrorLoadCharactersState({required this.errorStateType});

  final ErrorStateType errorStateType;

  @override
  List<Object?> get props => [errorStateType];
}
