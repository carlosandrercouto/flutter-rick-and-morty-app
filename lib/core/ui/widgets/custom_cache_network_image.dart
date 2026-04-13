import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  final String imageUrl;
  const CustomCacheNetworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 88,
      height: 88,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
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
      ),
      errorWidget: (context, url, error) => Container(
        width: 88,
        height: 88,
        color: const Color(0xFF252B3B),
        child: const Icon(
          Icons.person_rounded,
          color: Color(0xFF9BA3B8),
          size: 36,
        ),
      ),
    );
  }
}
