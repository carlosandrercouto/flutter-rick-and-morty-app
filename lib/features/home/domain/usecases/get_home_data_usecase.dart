import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_export.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_data_entity.dart';
import '../repositories/home_repository.dart';

/// Caso de uso para buscar os dados de tela da Home.
///
/// Delega para o [HomeRepository] para recuperar o agrupamento de
/// saldo financeiro e transações do usuário.
class GetHomeDataUseCase extends UseCase<HomeDataEntity, NoParams> {
  GetHomeDataUseCase({required this.repository});

  final HomeRepository repository;

  @override
  Future<Either<Failure?, HomeDataEntity>> call(NoParams params) async {
    return repository.getHomeData();
  }
}
