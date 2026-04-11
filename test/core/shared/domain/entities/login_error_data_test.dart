import 'package:flutter_template/core/enums/login_error_type_enum.dart';
import 'package:flutter_template/core/shared/domain/entities/login_error_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginErrorData Entity', () {
    test(
      'deve aplicar verificação por valor de igualdade pela chave do ErrorType',
      () {
        const entity1 = LoginErrorData(
          errorType: LoginErrorType.invalidUserOrPassword,
        );
        const entity2 = LoginErrorData(
          errorType: LoginErrorType.invalidUserOrPassword,
        );
        const entity3 = LoginErrorData(errorType: LoginErrorType.genericError);

        expect(entity1, equals(entity2));
        expect(entity1, isNot(equals(entity3)));
      },
    );
  });
}
