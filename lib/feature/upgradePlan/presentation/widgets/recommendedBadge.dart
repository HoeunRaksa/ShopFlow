import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecommendedBadge
    extends StatelessWidget {

  const RecommendedBadge({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal:10,
        vertical:4,
      ),

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(999),

        color:
        Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
      ),

      child: const Text(
        "Recommended",
      ),
    );
  }
}