import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home_bloc.dart';
import '../widgets/widgets_export.dart';

/// Tela principal da aplicação — estilo IMDb.
///
/// Responsável exclusivamente pelo carregamento e exibição dos dados do
/// episódio. Quando o episódio é carregado com sucesso, instancia o
/// [HomeCharactersWidget], que gerencia de forma autônoma o carregamento
/// da listagem de personagens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

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
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          buildWhen: (_, current) =>
              current is LoadingEpsodeState ||
              current is LoadedEpsodeState ||
              current is ErrorLoadEpsodeState,
          builder: (context, state) {
            if (state is LoadedEpsodeState) {
              return _buildLoadedState(state);
            } else if (state is ErrorLoadEpsodeState) {
              return _buildErrorState(state);
            }

            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  // Retorna widgets de acordo com o estados do bloc
  // ===================================================================================================================
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildLoadedState(LoadedEpsodeState state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header com metadados da série e do episódio
        SliverToBoxAdapter(
          child: HomeSeriesHeaderWidget(epsode: state.epsode),
        ),

        // Título da seção
        SliverToBoxAdapter(
          child: _buildSectionTitle('Personagens'),
        ),

        // Widget auto-suficiente — instanciado somente no sucesso do episódio
        SliverToBoxAdapter(
          child: HomeCharactersWidget(
            ids: state.epsode.characters,
            homeBloc: _homeBloc,
          ),
        ),

        // Espaçamento inferior
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildErrorState(ErrorLoadEpsodeState state) {
    return HomeErrorWidget(
      icon: Icons.tv_off_rounded,
      message: state.errorStateType.message,
      onTap: () => _homeBloc.add(const LoadEpsodeEvent(id: _epsodeId)),
    );
  }

  // Widgets auxiliares
  // ===================================================================================================================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
