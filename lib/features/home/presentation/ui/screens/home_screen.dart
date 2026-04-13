import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core_export.dart';
import '../../bloc/home_bloc.dart';
import '../widgets/widgets_export.dart';

/// Tela principal da aplicação.
///
/// Demonstra o fluxo completo da feature Home:
/// - Dados do episódio gerenciados pelo [HomeBloc]
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;
  final SessionHelper _sessionHelper = SessionHelper.instance;


  // ID do episódio exibido
  static const int _epsodeId = 28;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const LoadEpsodeEvent(id: _epsodeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderWidget(userName: _sessionHelper.userName),

            const SizedBox(height: 24),
            _buildSectionTitle(),
            const SizedBox(height: 12),
            // Seção do episódio — expande e rola
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                bloc: _homeBloc,
                listenWhen: (_, current) =>
                    current is ErrorLoadEpsodeState,
                listener: (context, state) {
                  // Listener para erros globais ou expiração de sessão
                },
                buildWhen: (_, current) =>
                    current is LoadingEpsodeState ||
                    current is LoadedEpsodeState ||
                    current is ErrorLoadEpsodeState,
                builder: (context, state) {
                  if (state is LoadedEpsodeState) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: EpsodeCardWidget(epsode: state.epsode),
                    );
                  } else if (state is ErrorLoadEpsodeState) {
                    return _buildEpsodeError(state);
                  }
                  return _buildLoading();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widgets auxiliares
  // ===================================================================================================================

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildEpsodeError(ErrorLoadEpsodeState state) {
    return HomeErrorWidget(
      icon: Icons.tv_off_rounded,
      message: state.errorStateType.message,
      onTap: () => _homeBloc.add(const LoadEpsodeEvent(id: _epsodeId)),
    );
  }

  Widget _buildSectionTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Icon(
            Icons.play_circle_fill_rounded,
            color: Color(0xFF6C63FF),
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Episódio em destaque',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
