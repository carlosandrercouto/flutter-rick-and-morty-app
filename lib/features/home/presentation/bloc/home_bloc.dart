import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/error_state_type_enum.dart';
import '../../../../core/errors/errors_export.dart';
import '../../data/datasources/home_datasource.dart';
import '../../domain/entities/entities_export.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/usecases_export.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC responsável pelo gerenciamento de estado da Home.
///
/// Orquestra o carregamento de episódios e personagens e expõe os estados
/// correspondentes para a camada de apresentação.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({HomeRepository? homeRepository})
    : _homeRepository = homeRepository ?? HomeDatasource(),
      super(HomeInitialState()) {
    on<LoadEpsodeEvent>(_onLoadEpsode);
    on<LoadCharactersEvent>(_onLoadCharacters);
  }

  /// Carrega os dados de um episódio pelo seu [id].
  Future<void> _onLoadEpsode(
    LoadEpsodeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(LoadingEpsodeState());

    final getEpsodeUseCase = GetEpsodeUseCase(repository: _homeRepository);
    final result = await getEpsodeUseCase(GetEpsodeParams(id: event.id));

    result.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(ErrorLoadEpsodeState(errorStateType: ErrorStateType.timeout));
        } else if (failure is SessionExpiredFailure) {
          emit(
            ErrorLoadEpsodeState(
              errorStateType: ErrorStateType.sessionExpired,
            ),
          );
        } else {
          emit(
            ErrorLoadEpsodeState(errorStateType: ErrorStateType.genericError),
          );
        }
      },
      (Epsode epsode) {
        emit(LoadedEpsodeState(epsode: epsode));
      },
    );
  }

  /// Carrega os personagens pelos seus [ids].
  Future<void> _onLoadCharacters(
    LoadCharactersEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(LoadingCharactersState());

    final useCase = GetCharactersUseCase(repository: _homeRepository);
    final result = await useCase(GetCharactersParams(ids: event.ids));

    result.fold(
      (failure) {
        if (failure is TimeoutFailure) {
          emit(
            ErrorLoadCharactersState(errorStateType: ErrorStateType.timeout),
          );
        } else if (failure is SessionExpiredFailure) {
          emit(
            ErrorLoadCharactersState(
              errorStateType: ErrorStateType.sessionExpired,
            ),
          );
        } else {
          emit(
            ErrorLoadCharactersState(
              errorStateType: ErrorStateType.genericError,
            ),
          );
        }
      },
      (List<CharacterEntity> characters) {
        emit(LoadedCharactersState(characters: characters));
      },
    );
  }
}
