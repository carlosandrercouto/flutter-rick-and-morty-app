import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/helpers/database_helper.dart';
import '../../../core/enums/cache_source_enum.dart';

/// Indicador visual que exibe a origem dos dados (Local / Remoto) e o tempo
/// restante até o cache expirar.
///
/// Atualiza o contador a cada segundo via [Timer.periodic].
///
/// Uso:
/// ```dart
/// CacheIndicatorWidget(
///   cacheKey: 'episode_28',
///   source: datasource.lastEpsodeSource,
/// )
/// ```
class CacheIndicatorWidget extends StatefulWidget {
  const CacheIndicatorWidget({
    super.key,
    required this.cacheKey,
    required this.source,
  });

  /// Chave usada para buscar o [CacheEntry] no banco.
  final String cacheKey;

  /// Origem dos dados exibida no badge.
  final CacheSource source;

  @override
  State<CacheIndicatorWidget> createState() => _CacheIndicatorWidgetState();
}

class _CacheIndicatorWidgetState extends State<CacheIndicatorWidget> {
  static const Duration _ttl = Duration(minutes: 1);

  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void didUpdateWidget(CacheIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinicia o contador quando a chave ou source mudam (novo carregamento)
    if (oldWidget.cacheKey != widget.cacheKey ||
        oldWidget.source != widget.source) {
      _timer?.cancel();
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startCountdown() async {
    // Consulta o banco para saber o instante real da última atualização
    final CacheEntry? entry = await DatabaseHelper.instance.get(
      key: widget.cacheKey,
    );

    if (!mounted) return;

    if (entry == null) {
      setState(() => _secondsRemaining = 0);
      return;
    }

    setState(
      () => _secondsRemaining = entry.secondsUntilExpiry(ttl: _ttl),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocal = widget.source == CacheSource.local;

    return Row(
      children: [
        Text(
          'Origem dos dados: ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: (isLocal ? const Color(0xFF3ECFCF) : const Color(0xFF6C63FF))
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  (isLocal ? const Color(0xFF3ECFCF) : const Color(0xFF6C63FF))
                      .withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone: banco de dados (local) ou nuvem (remoto)
              Icon(
                isLocal ? Icons.storage_rounded : Icons.cloud_download_rounded,
                size: 13,
                color: isLocal
                    ? const Color(0xFF3ECFCF)
                    : const Color(0xFF6C63FF),
              ),
              const SizedBox(width: 5),

              // Label da origem
              Text(
                isLocal ? 'Cache' : 'API',
                style: TextStyle(
                  color: isLocal
                      ? const Color(0xFF3ECFCF)
                      : const Color(0xFF6C63FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),

              // Separador + contador regressivo (só exibe quando há cache válido)
              if (_secondsRemaining > 0) ...[
                const SizedBox(width: 6),
                Container(
                  width: 1,
                  height: 10,
                  color: const Color(0xFF3D4560),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_secondsRemaining}s',
                  style: const TextStyle(
                    color: Color(0xFF9BA3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
