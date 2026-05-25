import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_style.dart';

class UpgradeHeader extends StatelessWidget {
  const UpgradeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    final titleSize = AppStyle.titleSize(context, w);
    final bodySize = AppStyle.bodySize(context, w);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Your Plan",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Upgrade your account to unlock more powerful features.",
          style: TextStyle(
            fontSize: bodySize,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}