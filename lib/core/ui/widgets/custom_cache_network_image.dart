import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Widget de imagem de personagem com carregamento escalonado e auto-retry.
///
/// **Estratégia anti-rate-limit (HTTP 429):**
/// O parâmetro [loadIndex] adiciona um delay inicial de `loadIndex * 200ms`
/// antes de iniciar o download — evita que todos os itens da lista disparem
/// requests simultâneos e causem rate limiting na CDN da API.
///
/// **Retry com backoff:**
/// Se ainda assim ocorrer erro (429 ou outro), retenta automaticamente até
/// [_maxRetries] vezes com backoff crescente antes de exibir o fallback.
class CustomCacheNetworkImage extends StatefulWidget {
  final String imageUrl;

  /// Posição do item na lista. Usado para escalonar o início do download.
  /// Ex: índice 0 → carrega imediatamente; índice 5 → aguarda 1000ms.
  final int loadIndex;

  const CustomCacheNetworkImage({
    super.key,
    required this.imageUrl,
    this.loadIndex = 0,
  });

  @override
  State<CustomCacheNetworkImage> createState() =>
      _CustomCacheNetworkImageState();
}

class _CustomCacheNetworkImageState extends State<CustomCacheNetworkImage> {
  static const double _size = 88.0;
  static const int _maxRetries = 3;

  // Delays de retry longos — adequados para rate limiting (429).
  static const _retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 3),
    Duration(seconds: 6),
  ];

  int _retrySeed = 0;
  bool _gaveUp = false;

  /// Controla se o delay inicial de escalonamento já passou.
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _scheduleInitialLoad();
  }

  /// Carrega imediatamente se a imagem já estiver no cache de disco.
  /// Caso contrário, aplica o delay escalonado para evitar rate limiting (HTTP 429).
  Future<void> _scheduleInitialLoad() async {
    if (widget.imageUrl.isEmpty) {
      if (mounted) setState(() => _ready = true);
      return;
    }

    // Verifica se já está no cache de disco do flutter_cache_manager.
    final fileInfo =
        await DefaultCacheManager().getFileFromCache(widget.imageUrl);

    if (!mounted) return;

    if (fileInfo != null) {
      // Cache HIT → não aplica delay, mostra na hora.
      setState(() => _ready = true);
      return;
    }

    // Cache MISS → aplica stagger para não saturar a CDN com requests simultâneos.
    final delay = Duration(milliseconds: widget.loadIndex * 200);
    if (delay == Duration.zero) {
      setState(() => _ready = true);
      return;
    }

    await Future.delayed(delay);
    if (!mounted) return;
    setState(() => _ready = true);
  }


  void _onError() {
    if (!mounted) return;

    if (_retrySeed >= _maxRetries) {
      setState(() => _gaveUp = true);
      return;
    }

    Future.delayed(_retryDelays[_retrySeed], () {
      if (!mounted) return;
      setState(() => _retrySeed++);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty || _gaveUp) {
      return const _ImageErrorFallback();
    }

    // Exibe placeholder durante o delay inicial de escalonamento.
    if (!_ready) return const _ImagePlaceholder();

    return CachedNetworkImage(
      key: ValueKey('${widget.imageUrl}_$_retrySeed'),
      imageUrl: widget.imageUrl,
      width: _size,
      height: _size,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 250),
      fadeOutDuration: const Duration(milliseconds: 100),
      memCacheWidth: (_size * 3).toInt(),
      memCacheHeight: (_size * 3).toInt(),
      placeholder: (context, url) => const _ImagePlaceholder(),
      errorWidget: (context, url, error) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _onError());
        return const _ImagePlaceholder();
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      color: const Color(0xFF252B3B),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: Color(0xFF6C63FF),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class _ImageErrorFallback extends StatelessWidget {
  const _ImageErrorFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      color: const Color(0xFF252B3B),
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF9BA3B8),
        size: 36,
      ),
    );
  }
}
