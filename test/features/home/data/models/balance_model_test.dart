import 'package:flutter_template/features/home/data/models/balance_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BalanceModel', () {
    test('deve criar BalanceModel perfeitamente a partir de um map preenchido', () {
      final map = {
        'available': 1500.50,
        'incomes': 2000.0,
        'expenses': 499.5,
      };

      final model = BalanceModel.fromMap(map: map);

      expect(model.available, 1500.50);
      expect(model.incomes, 2000.0);
      expect(model.expenses, 499.5);
    });

    test('deve lidar com valores nullos atribuindo 0.0 por padrao', () {
      final map = <String, dynamic>{};

      final model = BalanceModel.fromMap(map: map);

      expect(model.available, 0.0);
      expect(model.incomes, 0.0);
      expect(model.expenses, 0.0);
    });
  });
}
