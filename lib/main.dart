import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/helpers/environment_helper.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa dados de formatação de datas (pacote intl)
  await initializeDateFormatting('pt_BR', null);

  // Inicializa o EnvironmentHelper lendo o arquivo .env
  // antes de qualquer inicialização de classes
  await EnvironmentHelper.instance.init();

  runApp(const FlutterTemplateApp());
}

class FlutterTemplateApp extends StatelessWidget {
  const FlutterTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: RoutesList.HomeScreen.routeName,
      onGenerateRoute: getRoute,
    );
  }
}
