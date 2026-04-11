import 'package:flutter_template/features/home/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionEntity', () {
    test('deve aplicar verificação por valor de igualdade através do Equatable', () {
      final data = DateTime(2024, 05, 01);

      final entity1 = TransactionEntity(
        id: '123',
        name: 'Supermercado',
        amount: 80.0,
        date: data,
      );

      final entity2 = TransactionEntity(
        id: '123',
        name: 'Supermercado',
        amount: 80.0,
        date: data,
      );

      final entityDiferente = TransactionEntity(
        id: '999',
        name: 'Supermercado',
        amount: 80.0,
        date: data,
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entityDiferente)));
    });
  });
}
