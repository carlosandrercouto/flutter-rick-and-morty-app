// ignore_for_file: one_member_abstracts, avoid_types_as_parameter_names

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

/// Contrato base para todos os use cases.
///
/// [Type] é o tipo de retorno esperado em caso de sucesso.
/// [Params] é o tipo do objeto com os parâmetros necessários.
abstract class UseCase<Type, Params> {
  Future<Either<Failure?, Type>> call(Params params);
}

/// Usado quando o use case não recebe parâmetros.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
