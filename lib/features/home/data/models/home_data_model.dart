import '../../domain/entities/home_data_entity.dart';
import 'balance_model.dart';
import 'transaction_model.dart';

/// Model que faz parsing do payload geral da home.
class HomeDataModel extends HomeDataEntity {
  const HomeDataModel._internal({
    required super.balance,
    required super.transactions,
  });

  factory HomeDataModel.fromMap({required Map<String, dynamic> map}) {
    final balanceMap = map['balance'] as Map<String, dynamic>? ?? {};
    final transactionsList = map['transactions'] as List<dynamic>? ?? [];

    return HomeDataModel._internal(
      balance: BalanceModel.fromMap(map: balanceMap),
      transactions: transactionsList
          .map(
            (item) =>
                TransactionModel.fromMap(map: item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
