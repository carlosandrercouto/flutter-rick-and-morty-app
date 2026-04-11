import 'package:flutter_template/features/home/data/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionModel', () {
    test('deve criar o model corretamente e parsear a data ISO 8601', () {
      final map = {
        'id': 'abc-123',
        'name': 'Compra no Mercado',
        'amount': 250.75,
        'date': '2024-03-15T10:30:00Z',
      };

      final model = TransactionModel.fromMap(map: map);

      expect(model.id, 'abc-123');
      expect(model.name, 'Compra no Mercado');
      expect(model.amount, 250.75);
      expect(model.date, DateTime.parse('2024-03-15T10:30:00Z'));
    });
  });
}
