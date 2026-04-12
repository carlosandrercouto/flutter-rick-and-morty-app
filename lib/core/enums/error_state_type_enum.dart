enum ErrorStateType {
  timeout(message: 'Tempo limite excedido. Verifique sua conexão.'),
  noInternetConnection(message: 'Sem conexão com a internet.'),
  sessionExpired(message: 'Sessão expirada. Faça login novamente.'),
  genericError(message: 'Ocorreu um erro inesperado.');

  /// TODO: Substituir por key_name posteriormente, após implementação de internacionalização Mensagem de erro da API.
  final String message;

  const ErrorStateType({required this.message});
}
