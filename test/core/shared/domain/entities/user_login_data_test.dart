import 'package:flutter_template/core/shared/domain/entities/user_login_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserLoginData Entity', () {
    test('deve comparar igualdade de objeto corretamente usando propriedades', () {
      const entity1 = UserLoginData(
        token: 'token1',
        userId: 'ui1',
        name: 'Dev',
        email: 'dev@test.local',
      );

      const entity2 = UserLoginData(
        token: 'token1',
        userId: 'ui1',
        name: 'Dev',
        email: 'dev@test.local',
      );

      expect(entity1, equals(entity2));
    });
  });
}
