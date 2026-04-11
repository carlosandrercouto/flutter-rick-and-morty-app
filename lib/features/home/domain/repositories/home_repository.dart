import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_export.dart';
import '../entities/home_data_entity.dart';

/// Interface do repositório da feature Home.
///
/// Define o contrato de acesso a dados sem expor detalhes de implementação.
/// Implementado por [HomeDatasource] na camada de data.
abstract class HomeRepository {
  /// Busca os dados gerais da home do usuário.
  ///
  /// Retorna [Right] com [HomeDataEntity] em caso de sucesso,
  /// ou [Left] com [Failure] em caso de erro.
  Future<Either<Failure?, HomeDataEntity>> getHomeData();
}
