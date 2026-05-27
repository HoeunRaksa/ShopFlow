import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_style.dart';

class UpgradeHeader extends StatelessWidget {
  final double padding ;
  const UpgradeHeader({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    final bodySize = AppStyle.bodySize(context, w);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Choose Your Plan",
            style: TextStyle(fontSize: bodySize, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 8),

          Text(
            "Upgrade your account to unlock more powerful features.",
            style: TextStyle(
              fontSize: bodySize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
