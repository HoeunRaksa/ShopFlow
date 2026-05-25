import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanTitle extends StatelessWidget {
  final String title;
  final String price;

  const PlanTitle({super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          price,
          style: TextStyle(
            color:
            Theme.of(context)
                .colorScheme
                .primary,
          ),
        )
      ],
    );
  }
}