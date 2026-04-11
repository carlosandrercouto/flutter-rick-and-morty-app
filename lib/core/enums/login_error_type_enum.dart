/// Enum que representa os tipos de erro de login.
///
/// Segue o padrão do monetizze (ex: ProductStatus):
/// cada valor carrega seu próprio [apiMessage] como parâmetro,
/// e o lookup [fromString] usa [values.firstWhere] sobre esse campo.
enum LoginErrorType {
  invalidUserOrPassword(apiMessage: 'Usuário ou Senha Inválidos'),
  inactiveUser(apiMessage: 'Usuário inativo!'),
  genericError(apiMessage: null);

  final String? apiMessage;

  const LoginErrorType({required this.apiMessage});

  /// Retorna o [LoginErrorType] correspondente à mensagem de erro da API.
  ///
  /// Retorna [genericError] se a mensagem não for encontrada.
  static LoginErrorType fromString(String? message) {
    return LoginErrorType.values.firstWhere(
      (type) => type.apiMessage == message,
      orElse: () => LoginErrorType.genericError,
    );
  }
}
