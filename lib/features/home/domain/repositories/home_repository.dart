import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_export.dart';
import '../entities/entities_export.dart';

/// Interface do repositório da feature Home.
///
/// Define o contrato de acesso a dados sem expor detalhes de implementação.
/// Implementado por [HomeDatasource] na camada de data.
abstract class HomeRepository {
  /// Busca os dados gerais da home do usuário.
  ///
  /// Retorna [Right] com [HomeDataEntity] em caso de sucesso,
  /// ou [Left] com [Failure] em caso de erro.
  Future<Either<Failure?, HomeDataEntity>> getHomeTransactonsData();

  /// Busca os dados de um episódio pelo seu [id].
  ///
  /// Retorna [Right] com [Epsode] em caso de sucesso,
  /// ou [Left] com [Failure] em caso de erro.
  Future<Either<Failure?, Epsode>> getEpsode({required int id});

  /// Busca os dados de múltiplos personagens pelos seus [ids].
  ///
  /// Retorna [Right] com a lista de [CharacterEntity] ordenada
  /// alfabeticamente, ou [Left] com [Failure] em caso de erro.
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  });
}
