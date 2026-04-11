import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/features/login/data/models/user_login_data_model.dart';

void main() {
  group('UserLoginDataModel', () {
    test('fromMap deve mapear os dados corretamente quando enviar JSON válido', () {
      final map = {
        'token': 'mock_token',
        'userId': 'mock_id',
        'name': 'Test User',
        'email': 'test@test.com',
      };

      final model = UserLoginDataModel.fromMap(map: map);

      expect(model.token, 'mock_token');
      expect(model.userId, 'mock_id');
      expect(model.name, 'Test User');
      expect(model.email, 'test@test.com');
      expect(model.error, isNull);
    });

    test('fromMap deve definir valores padrão se map não possuir propriedades', () {
      final map = <String, dynamic>{};

      final model = UserLoginDataModel.fromMap(map: map);

      expect(model.token, '');
      expect(model.userId, '');
      expect(model.name, '');
      expect(model.email, '');
    });
  });
}
