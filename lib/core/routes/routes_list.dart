// ignore_for_file: constant_identifier_names

enum RoutesList {
  // Login
  LoginScreen('LoginScreen'),

  // Home
  HomeScreen('HomeScreen'),

  // Characters
  CharactersScreen('CharactersScreen');

  // Não altere os parametros
  final String routeName;

  const RoutesList(this.routeName);
}
