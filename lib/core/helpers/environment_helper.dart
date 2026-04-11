import 'dart:developer' as dev;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper responsável pela leitura e disponibilização das variáveis de ambiente.
///
/// Segue o padrão do monetizze:
/// - Singleton acessível via [instance]
/// - Inicializado uma única vez em [init], chamado no [main] antes do runApp
/// - Expõe as variáveis via getters tipados
///
/// Arquivo de configuração: `.env` na raiz do projeto.
class EnvironmentHelper {
  late DotEnv _dotEnv;

  static final EnvironmentHelper _instance = EnvironmentHelper();
  static EnvironmentHelper get instance => _instance;

  late String _apiBaseUrl;
  late bool _useMock;

  /// Inicializa o helper carregando o arquivo [envFile] (padrão: `.env`).
  ///
  /// Deve ser chamado no [main] antes do [runApp]:
  /// ```dart
  /// await EnvironmentHelper.instance.init();
  /// ```
  Future<void> init({
    String? envFile,
    DotEnv? flutterDotEnv,
  }) async {
    _dotEnv = flutterDotEnv ?? dotenv;

    try {
      await _dotEnv.load(fileName: envFile ?? '.env');
      _apiBaseUrl = _getEnvData(fromKey: 'API_BASE_URL');
      _useMock = _getEnvData(fromKey: 'USE_MOCK').toLowerCase() == 'true';
      dev.log('Successful', name: 'EnvironmentHelper: init');
    } catch (error, stackTrace) {
      dev.log('Error: ${error.toString()}', name: 'EnvironmentHelper: init');
      dev.log(stackTrace.toString(), name: 'EnvironmentHelper: init');
    }
  }

  /// URL base da API principal.
  String get apiBaseUrl => _apiBaseUrl;

  /// Quando [true], os datasources retornam dados mockados em vez de chamar a API.
  bool get useMock => _useMock;

  /// Indica se o ambiente é de desenvolvimento (URL contém "dev").
  bool get isDevEnvironment => _apiBaseUrl.contains('dev');

  String _getEnvData({required String fromKey}) {
    String? result;

    try {
      result = _dotEnv.maybeGet(fromKey, fallback: null);

      if (result == null) {
        throw Exception('Env key not found: $fromKey');
      }
    } catch (error, stackTrace) {
      dev.log('Error: ${error.toString()}', name: 'EnvironmentHelper: _getEnvData');
      dev.log(stackTrace.toString(), name: 'EnvironmentHelper: _getEnvData');
    }

    return result ?? '';
  }
}
