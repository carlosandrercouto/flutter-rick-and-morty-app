import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helpers/session_helper.dart';
import '../../../data/datasources/home_datasource.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../bloc/home_bloc.dart';
import '../widgets/balance_card_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/transaction_list_widget.dart';

/// Tela principal da aplicação.
///
/// Demonstra o fluxo completo da feature Home:
/// - Dados do usuário recuperados do [SessionHelper]
/// - Lista de transações gerenciada pelo [HomeBloc]
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(homeRepository: HomeDatasource())
        ..add(const HomeLoadTransactionsEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late HomeBloc _homeBloc;
  final String _userName = SessionHelper.instance.userName;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderWidget(userName: _userName),
            BlocBuilder<HomeBloc, HomeState>(
              bloc: _homeBloc,
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return BalanceCardWidget(balance: state.homeData.balance);
                }
                return const BalanceCardWidget();
              },
            ),
            const SizedBox(height: 24),
            _buildTransactionListTitle(context),
            const SizedBox(height: 8),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                bloc: _homeBloc,
                listenWhen: (_, current) {
                  return [
                    HomeErrorUserSessionState,
                  ].contains(current.runtimeType);
                },
                listener: (context, state) {
                  if (state is HomeErrorUserSessionState) {
                    // Exemplo: redirecionar para login
                    // Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
                  }
                },
                buildWhen: (previous, current) {
                  return (current is HomeLoadingState ||
                      current is HomeLoadedState ||
                      current is HomeErrorState ||
                      current is HomeErrorTimeoutState ||
                      current is HomeErrorUserSessionState);
                },
                builder: (BuildContext context, HomeState currentState) {
                  if (currentState is HomeLoadedState) {
                    return _loadedHomeState(currentState.homeData.transactions);
                  } else if (currentState is HomeErrorTimeoutState) {
                    return _errorTimeoutHomeState();
                  } else if (currentState is HomeErrorUserSessionState) {
                    // Fallback visual case not immediately redirected
                    return _errorGenericHomeState('Sessão expirada. Faça login novamente.');
                  } else if (currentState is HomeErrorState) {
                    return _errorGenericHomeState(currentState.message);
                  }

                  return _loadingHomeState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Retorna widget de acordo com o estado retornado pelo Bloc
  // ===================================================================================================================

  Widget _loadingHomeState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _loadedHomeState(List<TransactionEntity> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma transação encontrada.',
          style: TextStyle(color: Color(0xFF9BA3B8), fontSize: 14),
        ),
      );
    }
    return TransactionListWidget(transactions: transactions);
  }

  Widget _errorTimeoutHomeState() {
    return _buildErrorView(
      icon: Icons.wifi_off_rounded,
      message: 'Sem conexão com a internet.\nToque para tentar novamente.',
    );
  }

  Widget _errorGenericHomeState(String? message) {
    return _buildErrorView(
      icon: Icons.error_outline_rounded,
      message: message ?? 'Erro ao carregar transações.\nToque para tentar novamente.',
    );
  }

  Widget _buildErrorView({required IconData icon, required String message}) {
    return Center(
      child: InkWell(
        onTap: () => _homeBloc.add(const HomeLoadTransactionsEvent()),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF9BA3B8), size: 42),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(color: Color(0xFF9BA3B8), fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionListTitle(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Últimas transações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            'Ver todas',
            style: TextStyle(
              color: Color(0xFF6C63FF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
