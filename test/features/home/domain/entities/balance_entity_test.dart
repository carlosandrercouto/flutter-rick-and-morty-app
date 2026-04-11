import 'package:flutter_template/features/home/domain/entities/balance_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BalanceEntity', () {
    test('deve suportar comparação de valor via Equatable corretamente', () {
      const entity1 = BalanceEntity(
        available: 100.0,
        incomes: 50.0,
        expenses: 10.0,
      );

      const entity2 = BalanceEntity(
        available: 100.0,
        incomes: 50.0,
        expenses: 10.0,
      );

      const entityDiferente = BalanceEntity(
        available: 200.0,
        incomes: 50.0,
        expenses: 10.0,
      );

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entityDiferente)));
    });
  });
}
