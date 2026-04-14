import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/character_entity.dart';
import '../../bloc/home_bloc.dart';
import 'character_item_widget.dart';
import 'home_error_widget.dart';

/// Widget auto-suficiente que gerencia o carregamento e exibição dos
/// personagens de um episódio.
///
/// Responsabilidades:
/// - Despachar [LoadCharactersEvent] ao ser instanciado
/// - Escutar apenas os estados de personagens via [buildWhen]
/// - Renderizar loading, lista e erro com métodos isolados e legíveis
class HomeCharactersWidget extends StatefulWidget {
  const HomeCharactersWidget({
    super.key,
    required this.ids,
    required this.homeBloc,
  });

  /// IDs dos personagens a serem carregados.
  final List<int> ids;

  /// Referência ao BLoC já instanciado na árvore de widgets.
  final HomeBloc homeBloc;

  @override
  State<HomeCharactersWidget> createState() => _HomeCharactersWidgetState();
}

class _HomeCharactersWidgetState extends State<HomeCharactersWidget> {
  @override
  void initState() {
    super.initState();
    widget.homeBloc.add(LoadCharactersEvent(ids: widget.ids));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: widget.homeBloc,
      buildWhen: (_, current) =>
          current is LoadingCharactersState ||
          current is LoadedCharactersState ||
          current is ErrorLoadCharactersState,
      builder: (context, state) {
        if (state is LoadedCharactersState) {
          return _builLoadedState(state.characters);
        } else if (state is ErrorLoadCharactersState) {
          return _buildErrorState(state);
        }

        return _buildLoadingState();
      },
    );
  }

  // Retorna widgets de acordo com o estados do bloc
  // ===================================================================================================================
  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6C63FF),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _builLoadedState(List<CharacterEntity> characters) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: characters.length,
      itemBuilder: (context, index) =>
          CharacterItemWidget(character: characters[index], loadIndex: index),
    );
  }

  Widget _buildErrorState(ErrorLoadCharactersState state) {
    return HomeErrorWidget(
      icon: Icons.people_alt_outlined,
      message: state.errorStateType.message,
      onTap: () => widget.homeBloc.add(LoadCharactersEvent(ids: widget.ids)),
    );
  }
}
