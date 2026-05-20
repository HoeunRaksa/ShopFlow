import 'package:flutter/material.dart';

class HomeEmptyState extends StatelessWidget {
  final double bodySize;

  const HomeEmptyState({super.key, required this.bodySize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            "No products yet",
            style: TextStyle(
              fontSize: bodySize,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}