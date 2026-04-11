import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/helpers/environment_helper.dart';
import 'features/login/data/datasources/login_datasource.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/login/presentation/ui/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa dados de formatação de datas (pacote intl)
  await initializeDateFormatting('pt_BR', null);

  // Inicializa o EnvironmentHelper lendo o arquivo .env
  // antes de qualquer outra coisa — igual ao padrão monetizze
  await EnvironmentHelper.instance.init();

  runApp(const FlutterTemplateApp());
}

class FlutterTemplateApp extends StatelessWidget {
  const FlutterTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Template',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
      ),
      home: BlocProvider(
        create: (_) => LoginBloc(
          loginRepository: LoginDatasource(),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}
