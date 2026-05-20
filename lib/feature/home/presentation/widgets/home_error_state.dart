import 'package:flutter/material.dart';

class HomeErrorState extends StatelessWidget {
  final Object error;
  final double iconSize;
  final VoidCallback onRetry;

  const HomeErrorState({
    super.key,
    required this.error,
    required this.iconSize,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: iconSize + 16,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Something went wrong",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Try Again"),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF185FA5),
                backgroundColor:
                const Color(0xFF185FA5).withOpacity(0.08),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}