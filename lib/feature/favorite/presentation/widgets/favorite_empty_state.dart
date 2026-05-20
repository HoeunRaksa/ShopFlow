import 'package:flutter/material.dart';

class FavoriteEmptyState extends StatelessWidget {
  final double bodySize;

  const FavoriteEmptyState({super.key, required this.bodySize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: Colors.red.shade300,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No favorites yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap the heart on any product\nto save it here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}