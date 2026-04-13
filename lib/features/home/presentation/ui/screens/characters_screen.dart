import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/character_entity.dart';
import '../../bloc/home_bloc.dart';
import '../widgets/character_item_widget.dart';

/// Screen com a listagem dos personagens de um episódio, em ordem alfabética.
class CharactersScreen extends StatefulWidget {
  const CharactersScreen({
    super.key,
    required this.characterIds,
    required this.episodeName,
  });

  final List<int> characterIds;
  final String episodeName;

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(LoadCharactersEvent(ids: widget.characterIds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                bloc: _homeBloc,
                buildWhen: (_, current) =>
                    current is LoadingCharactersState ||
                    current is LoadedCharactersState ||
                    current is ErrorLoadCharactersState,
                builder: (context, state) {
                  if (state is LoadedCharactersState) {
                    return _buildList(state.characters);
                  } else if (state is ErrorLoadCharactersState) {
                    return _buildError(state);
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 24, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Personagens',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  widget.episodeName,
                  style: const TextStyle(
                    color: Color(0xFF9BA3B8),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Contador de personagens
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${widget.characterIds.length} personagens',
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<CharacterEntity> characters) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: characters.length,
      itemBuilder: (context, index) =>
          CharacterItemWidget(character: characters[index]),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildError(ErrorLoadCharactersState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_alt_outlined, color: Color(0xFF9BA3B8), size: 48),
          const SizedBox(height: 12),
          Text(
            state.errorStateType.message,
            style: const TextStyle(color: Color(0xFF9BA3B8), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () =>
                _homeBloc.add(LoadCharactersEvent(ids: widget.characterIds)),
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF6C63FF)),
            label: const Text(
              'Tentar novamente',
              style: TextStyle(color: Color(0xFF6C63FF)),
            ),
          ),
        ],
      ),
    );
  }
}
