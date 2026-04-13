import 'dart:developer';

/// Helper singleton para gerenciar dados da sessão do usuário.
/// 
/// Armazena informações temporárias como token e nome do usuário
/// para serem acessadas globalmente no app.
class SessionHelper {
  static final SessionHelper _instance = SessionHelper._internal();
  static SessionHelper get instance => _instance;

  SessionHelper._internal();

  String _token = '';
  String _userName = 'Rick Sanchez'; // Valor padrão para o app simplificado
  String _userId = '';
  String _userEmail = '';

  String get token => _token;
  String get userName => _userName;
  String get userId => _userId;
  String get userEmail => _userEmail;

  bool get isAuthenticated => _token.isNotEmpty;
  bool get isLogged => isAuthenticated;


  /// Atualiza os dados da sessão após o login.
  void updateSession({
    required String token,
    required String userName,
    required String userId,
    required String userEmail,
  }) {
    _token = token;
    _userName = userName;
    _userId = userId;
    _userEmail = userEmail;
    log('Session updated for user: $userName', name: 'SessionHelper');
  }

  /// Limpa os dados da sessão (logout).
  void clearSession() {
    _token = '';
    _userName = '';
    _userId = '';
    _userEmail = '';
    log('Session cleared', name: 'SessionHelper');
  }
}
