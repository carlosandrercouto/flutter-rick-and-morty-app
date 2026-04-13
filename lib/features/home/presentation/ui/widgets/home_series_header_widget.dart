import 'package:flutter/material.dart';

import '../../../domain/entities/epsode.dart';

/// Header estilo IMDb que exibe os metadados da série e do episódio.
///
/// Exibe o título fixo da série, e o episódio/nome/data quando [epsode] não
/// for nulo (i.e., após o carregamento).
class HomeSeriesHeaderWidget extends StatelessWidget {
  const HomeSeriesHeaderWidget({super.key, this.epsode});

  final Epsode? epsode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Linha do título + badge ─────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Rick e Morty',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.2,
                  ),
                ),
              ),
              _RatingBadge(),
            ],
          ),

          const SizedBox(height: 14),

          // ── Skeleton ou dados do episódio ────────────────────────────────
          if (epsode == null)
            _buildSkeleton()
          else
            _buildEpisodeInfo(epsode!),
        ],
      ),
    );
  }

  Widget _buildEpisodeInfo(Epsode ep) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Código + nome do episódio
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF3ECFCF).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFF3ECFCF).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                ep.epsode,
                style: const TextStyle(
                  color: Color(0xFF3ECFCF),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ep.name,
                style: const TextStyle(
                  color: Color(0xFFE0E4F0),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Data de exibição
        Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFF6B7491),
              size: 13,
            ),
            const SizedBox(width: 6),
            Text(
              ep.airDate,
              style: const TextStyle(
                color: Color(0xFF6B7491),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
        _Divider(),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBox(width: 180, height: 16),
        const SizedBox(height: 8),
        _SkeletonBox(width: 120, height: 12),
        const SizedBox(height: 20),
        _Divider(),
      ],
    );
  }
}

// ── Sub-widgets privados ────────────────────────────────────────────────────

class _RatingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF5C518).withValues(alpha: 0.9),
            const Color(0xFFE8B400).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: Colors.black, size: 14),
          SizedBox(width: 4),
          Text(
            '9.2',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF252B3B),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withValues(alpha: 0.5),
            const Color(0xFF3ECFCF).withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
