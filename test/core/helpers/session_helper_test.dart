import 'package:flutter_template/core/helpers/session_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SessionHelper sessionHelper;

  setUp(() {
    sessionHelper = SessionHelper.instance;
    sessionHelper.clearSession();
  });

  group('SessionHelper', () {
    test('should start with default values', () {
      expect(sessionHelper.isAuthenticated, isFalse);
      expect(sessionHelper.userName, 'Rick Sanchez'); // Default set for simplification
    });

    test('should update session correctly', () {
      sessionHelper.updateSession(
        token: 'token123',
        userName: 'Morty Smith',
        userId: 'id456',
        userEmail: 'morty@citadel.com',
      );

      expect(sessionHelper.isAuthenticated, isTrue);
      expect(sessionHelper.token, 'token123');
      expect(sessionHelper.userName, 'Morty Smith');
      expect(sessionHelper.userId, 'id456');
      expect(sessionHelper.userEmail, 'morty@citadel.com');
    });

    test('should clear session correctly', () {
      sessionHelper.updateSession(
        token: 'token123',
        userName: 'Morty Smith',
        userId: 'id456',
        userEmail: 'morty@citadel.com',
      );

      sessionHelper.clearSession();

      expect(sessionHelper.isAuthenticated, isFalse);
      expect(sessionHelper.token, isEmpty);
      expect(sessionHelper.userName, isEmpty);
    });
  });
}
