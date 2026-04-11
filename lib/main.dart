import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/login/data/datasources/login_datasource.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/login/presentation/ui/login_screen.dart';

void main() {
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
        // Injeta o LoginBloc com o datasource mockado.
        // Em produção, troque LoginDatasource por uma implementação real
        // que utilize ApiService + ApiEndpoints.
        create: (_) => LoginBloc(
          loginRepository: LoginDatasource(),
        ),
        child: const LoginScreen(),
      ),
    );
  }
}
