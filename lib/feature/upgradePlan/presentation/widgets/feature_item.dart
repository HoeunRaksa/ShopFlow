import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:
      const EdgeInsets.only(bottom:8),

      child: Row(
        children: [

          Icon(
            Icons.check_circle_rounded,
            size:18,
            color:
            Theme.of(context)
                .colorScheme
                .primary,
          ),

          const SizedBox(width:8),

          Expanded(
            child: Text(text),
          )
        ],
      ),
    );
  }
}