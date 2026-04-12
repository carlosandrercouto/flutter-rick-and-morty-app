import 'package:flutter_template/features/home/domain/entities/balance_entity.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';
import 'package:flutter_template/features/home/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeDataEntity', () {
    test('deve validar instanciação e igualdade por valor via Equatable', () {
      const balance = BalanceEntity(available: 10, incomes: 20, expenses: 5);
      final transactions = <TransactionEntity>[];

      final entity1 = HomeDataEntity(
        balance: balance,
        transactionsList: transactions,
      );

      final entity2 = HomeDataEntity(
        balance: balance,
        transactionsList: transactions,
      );

      expect(entity1, equals(entity2));
    });
  });
}
