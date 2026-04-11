import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/presentation/ui/screens/home_screen.dart';
import '../../features/login/data/datasources/login_datasource.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';
import '../../features/login/presentation/ui/screens/login_screen.dart';
import 'routes_list.dart';

Map<String, dynamic> routes = <String, dynamic>{
  // Feature Login
  RoutesList.LoginScreen.routeName: (_) => BlocProvider(
        create: (_) => LoginBloc(loginRepository: LoginDatasource()),
        child: const LoginScreen(),
      ),

  // Feature Home
  RoutesList.HomeScreen.routeName: (_) => const HomeScreen(),
};

List<String> routesRoutedByCupertino = [];
List<String> animatedRoutes = [
  RoutesList.LoginScreen.routeName,
  RoutesList.HomeScreen.routeName,
];

Function router = (settings, screen) {
  // Verifica se a rota possui animação customizada
  if (animatedRoutes.contains(settings.name)) {
    return _buildAnimatedPageRoute(settings, screen);
  }

  // Usa CupertinoPageRoute para rotas estilo iOS
  if (routesRoutedByCupertino.contains(settings.name)) {
    return _buildCupertinoPageRoute(settings, screen);
  }

  // Padrão: MaterialPageRoute para the other routes
  return _buildMaterialPageRoute(settings, screen);
};

Route getRoute(RouteSettings settings) {
  if (routes.containsKey(settings.name)) {
    final routeName = settings.name;

    if (routeName != null && routeName.isNotEmpty) {
      log(routeName, name: 'Push routeName:');
    } else {
      log('Route name is null or empty', name: 'Push routeName Error:');
    }

    return router(settings, routes[settings.name](settings.arguments));
  }

  log('Route ${settings.name} not found', name: 'Push routeName Error:');
  
  // Rota de fallback padrão
  return _buildMaterialPageRoute(settings, const Scaffold(
    body: Center(child: Text('Rota não encontrada')),
  ));
}

MaterialPageRoute _buildMaterialPageRoute(RouteSettings settings, dynamic builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => builder,
  );
}

CupertinoPageRoute _buildCupertinoPageRoute(RouteSettings settings, dynamic builder) {
  return CupertinoPageRoute(
    settings: settings,
    builder: (context) => builder,
  );
}

PageRouteBuilder _buildAnimatedPageRoute(RouteSettings settings, dynamic builder) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder,
    transitionDuration: const Duration(milliseconds: 700),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var fadeAnimation = animation.drive(
        Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
      );

      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    },
  );
}
