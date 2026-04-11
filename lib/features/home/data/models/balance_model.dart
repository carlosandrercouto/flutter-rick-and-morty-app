import '../../domain/entities/balance_entity.dart';

/// Model responsável por fazer o parsing do saldo retornado pela API.
class BalanceModel extends BalanceEntity {
  const BalanceModel._internal({
    required super.available,
    required super.incomes,
    required super.expenses,
  });

  factory BalanceModel.fromMap({required Map<String, dynamic> map}) {
    return BalanceModel._internal(
      available: (map['available'] as num?)?.toDouble() ?? 0.0,
      incomes: (map['incomes'] as num?)?.toDouble() ?? 0.0,
      expenses: (map['expenses'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
