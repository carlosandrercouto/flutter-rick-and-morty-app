import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/features/home/data/models/home_data_model.dart';
import 'package:flutter_template/features/home/data/models/balance_model.dart';
import 'package:flutter_template/features/home/data/models/transaction_model.dart';

void main() {
  group('HomeDataModel', () {
    test('fromMap deve mapear corretamente com dados válidos', () {
      final map = {
        'balance': {
          'id': 'abc',
          'value': 1500.5,
          'visible': true,
        },
        'transactions': [
          {
            'id': '1',
            'name': 'Test 1',
            'amount': 25.0,
            'date': '2024-03-15T10:30:00Z'
          }
        ]
      };

      final model = HomeDataModel.fromMap(map: map);

      expect(model.balance, isA<BalanceModel>());
      expect(model.transactions, isA<List<TransactionModel>>());
      expect(model.transactions.length, 1);
    });

    test('fromMap deve definir coleções/objetos vazios em map faltante', () {
      final map = <String, dynamic>{};

      final model = HomeDataModel.fromMap(map: map);

      expect(model.balance, isA<BalanceModel>());
      expect(model.transactions, isEmpty);
    });
  });
}
