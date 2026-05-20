import 'package:flutter/material.dart';
import '../../../../core/app_style.dart';

class BlockSocial extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const BlockSocial({
    super.key,
    this.title = 'Socials',
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final theme = Theme.of(context).colorScheme;
    final textBodySize = AppStyle.bodySize(context, w * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(
            title,
            style: TextStyle(
              color: theme.onSurface,
              fontSize: textBodySize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}