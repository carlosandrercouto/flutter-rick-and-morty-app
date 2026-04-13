import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/errors_export.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/epsode.dart';
import '../repositories/home_repository.dart';

/// Parâmetros necessários para buscar um episódio.
class GetEpsodeParams extends Equatable {
  final int id;

  const GetEpsodeParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Caso de uso para buscar os dados de um episódio pelo seu [id].
///
/// Delega para o [HomeRepository] a chamada à fonte de dados,
/// retornando a entidade [Epsode] ou uma [Failure].
class GetEpsodeUseCase extends UseCase<Epsode, GetEpsodeParams> {
  GetEpsodeUseCase({required this.repository});

  final HomeRepository repository;

  @override
  Future<Either<Failure?, Epsode>> call(GetEpsodeParams params) async {
    return repository.getEpsode(id: params.id);
  }
}
