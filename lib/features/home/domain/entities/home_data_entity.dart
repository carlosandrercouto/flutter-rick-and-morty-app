import 'package:equatable/equatable.dart';

import 'balance_entity.dart';
import 'transaction_entity.dart';

/// Entidade raiz que agrupa todos os dados exibidos na Home Screen.
class HomeDataEntity extends Equatable {
  final BalanceEntity balance;
  final List<TransactionEntity> transactions;

  const HomeDataEntity({
    required this.balance,
    required this.transactions,
  });

  @override
  List<Object?> get props => [balance, transactions];
}
