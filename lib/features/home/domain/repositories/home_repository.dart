import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_export.dart';
import '../entities/entities_export.dart';

/// Interface do repositório da feature Home.
abstract class HomeRepository {
  /// Busca os dados de um episódio pelo seu [id].
  Future<Either<Failure?, Epsode>> getEpsode({required int id});

  /// Busca os dados de múltiplos personagens pelos seus [ids].
  Future<Either<Failure?, List<CharacterEntity>>> getCharacters({
    required List<int> ids,
  });
}
