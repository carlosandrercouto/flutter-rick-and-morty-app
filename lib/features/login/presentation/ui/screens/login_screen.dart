import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routes_list.dart';
import '../../bloc/login_bloc.dart';
import '../widgets/widgets_export.dart';

/// Tela de Login do aplicativo.
///
/// Utiliza [BlocConsumer] seguindo as diretrizes bloc:
/// - [listener] para side-effects (navegação, snackbars)
/// - [builder] delegando a construção visual para os métodos específicos
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginBloc _loginBloc;
  bool _isShowingLoading = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  void _handleState(BuildContext context, LoginState state) {
    if (state is RequestingLoginState) {
      _showLoading();
    } else if (state is RequestedLoginState) {
      _dismissLoading();
      Navigator.of(
        context,
      ).pushReplacementNamed(RoutesList.HomeScreen.routeName);
    } else if (state is ErrorRequestLoginState) {
      _dismissLoading();
      _showSnackbar(context, state.errorStateMessage);
    }
  }

  void _onLoginSubmitted(String email, String password) {
    _loginBloc.add(RequestLoginEvent(email: email, password: password));
  }

  void _showLoading() {
    if (_isShowingLoading) return;
    _isShowingLoading = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _dismissLoading() {
    if (!_isShowingLoading) return;
    _isShowingLoading = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1117),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocConsumer<LoginBloc, LoginState>(
                bloc: _loginBloc,
                listener: _handleState,
                buildWhen: (previous, current) =>
                    current is LoginInitialState ||
                    current is ErrorRequestLoginState,
                builder: (context, state) {
                  // Como a UI da tela de login será quase sempre a mesma
                  // independentemente do estado (sendo apenas sobreposta por diálogos de loading),
                  // retornamos o método padrão que monta os elementos isolados.
                  return _loginFormState();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginFormState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 60),
        const LoginHeaderWidget(),
        const SizedBox(height: 48),
        LoginFormWidget(onLoginSubmitted: _onLoginSubmitted),
        const SizedBox(height: 24),
      ],
    );
  }
}
