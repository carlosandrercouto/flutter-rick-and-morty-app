import 'package:equatable/equatable.dart';

/// Entidade que representa o saldo financeiro do usuário e resumos monetários.
class BalanceEntity extends Equatable {
  final double available;
  final double incomes;
  final double expenses;

  const BalanceEntity({
    required this.available,
    required this.incomes,
    required this.expenses,
  });

  @override
  List<Object?> get props => [available, incomes, expenses];
}
