import 'package:flutter/material.dart';

import '../../../../../core/routes/routes_list.dart';
import '../../../domain/entities/epsode.dart';

class EpsodeCardWidget extends StatelessWidget {
  const EpsodeCardWidget({super.key, required this.epsode});

  final Epsode epsode;

  void _navigateToCharacters(BuildContext context) {
    Navigator.of(context).pushNamed(
      RoutesList.CharactersScreen.routeName,
      arguments: {
        'characterIds': epsode.characters,
        'episodeName': epsode.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge do código do episódio
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              epsode.epsode,
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Nome do episódio
          Text(
            epsode.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          // Data de exibição
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFF9BA3B8),
                size: 13,
              ),
              const SizedBox(width: 6),
              Text(
                epsode.airDate,
                style: const TextStyle(
                  color: Color(0xFF9BA3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Card de personagens com botão de navegação
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF171B26),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF252B3B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people_alt_rounded,
                            color: Color(0xFF3ECFCF),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Personagens',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3ECFCF).withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${epsode.characters.length}',
                              style: const TextStyle(
                                color: Color(0xFF3ECFCF),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: epsode.characters
                            .map((id) => _CharacterChip(id: id))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                // Botão de navegação
                InkWell(
                  onTap: () => _navigateToCharacters(context),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF).withValues(alpha: 0.15),
                          const Color(0xFF3ECFCF).withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      border: const Border(
                        top: BorderSide(color: Color(0xFF252B3B)),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt_rounded,
                          color: Color(0xFF6C63FF),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Ver todos os personagens',
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF6C63FF),
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip que exibe o ID do personagem.
class _CharacterChip extends StatelessWidget {
  const _CharacterChip({required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF252B3B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF313B52)),
      ),
      child: Text(
        '#$id',
        style: const TextStyle(
          color: Color(0xFF9BA3B8),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
