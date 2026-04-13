import 'package:flutter/material.dart';

class HomeErrorWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onTap;

  const HomeErrorWidget({
    super.key,
    required this.icon,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF9BA3B8), size: 42),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Color(0xFF9BA3B8), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: onTap,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
