import 'package:flutter_template/core/enums/login_error_type_enum.dart';
import 'package:flutter_template/features/login/data/models/login_error_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginErrorDataModel', () {
    test('deve interpretar a string de erro a partir do map para enumerador corretamente', () {
      final map = {
        'error': 'invalidMethod',
      };

      final model = LoginErrorDataModel.fromMap(map: map);

      expect(model.errorType, LoginErrorType.fromString('invalidMethod'));
    });
  });
}
