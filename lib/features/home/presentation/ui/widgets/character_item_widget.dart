import 'package:flutter/material.dart';

import '../../../domain/entities/character_entity.dart';

/// Item de personagem exibido na listagem.
class CharacterItemWidget extends StatelessWidget {
  const CharacterItemWidget({super.key, required this.character});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171B26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF252B3B)),
      ),
      child: Row(
        children: [
          // Avatar com hero animation
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Hero(
              tag: 'character-${character.id}',
              child: Image.network(
                character.imageUrl,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => Container(
                  width: 88,
                  height: 88,
                  color: const Color(0xFF252B3B),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Color(0xFF9BA3B8),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StatusDot(status: character.status),
                      const SizedBox(width: 5),
                      Text(
                        '${character.status} · ${character.species}',
                        style: const TextStyle(
                          color: Color(0xFF9BA3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF6C63FF),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          character.locationName,
                          style: const TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF3D4560),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final String status;

  Color get _color {
    switch (status.toLowerCase()) {
      case 'alive':
        return const Color(0xFF3EFFC8);
      case 'dead':
        return const Color(0xFFFF6B8A);
      default:
        return const Color(0xFF9BA3B8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: _color.withValues(alpha: 0.5), blurRadius: 4),
        ],
      ),
    );
  }
}
