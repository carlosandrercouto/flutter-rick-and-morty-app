import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/errors_export.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/character_entity.dart';
import '../repositories/home_repository.dart';

/// Parâmetros para busca de múltiplos personagens.
class GetCharactersParams extends Equatable {
  final List<int> ids;

  const GetCharactersParams({required this.ids});

  @override
  List<Object?> get props => [ids];
}

/// Caso de uso para buscar os dados dos personagens de um episódio.
///
/// Recebe uma lista de [ids] extraídos das URLs da entidade [Epsode]
/// e delega para o [HomeRepository].
class GetCharactersUseCase
    extends UseCase<List<CharacterEntity>, GetCharactersParams> {
  GetCharactersUseCase({required this.repository});

  final HomeRepository repository;

  @override
  Future<Either<Failure?, List<CharacterEntity>>> call(
    GetCharactersParams params,
  ) async {
    return repository.getCharacters(ids: params.ids);
  }
}
