import 'package:flutter/material.dart';
import 'package:newprovider/feature/upgradePlan/presentation/widgets/plan_title.dart';
import 'package:newprovider/feature/upgradePlan/presentation/widgets/recommendedBadge.dart';

import '../../../../core/app_style.dart';
import 'feature_item.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final String buttonText;
  final bool isCurrent;
  final bool isHighlighted;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.buttonText,
    required this.onTap,
    this.isCurrent = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = AppStyle.screenWidth(context);

    return Container(
      padding: EdgeInsets.all(AppStyle.padding(context, w)),

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,

        borderRadius: BorderRadius.circular(AppStyle.cardRadius(context, w)),

        border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          if (isHighlighted) const RecommendedBadge(),

          PlanTitle(title: title, price: price),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 12),

          ...features.map((e) => FeatureItem(text: e)),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: isCurrent ? null : onTap,

              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
