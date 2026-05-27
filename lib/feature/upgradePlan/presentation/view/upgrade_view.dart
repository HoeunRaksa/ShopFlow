import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_style.dart';
import '../widgets/plans_section.dart';
import '../widgets/update_header.dart';

class UpgradeView extends ConsumerWidget {
  const UpgradeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final maxWidth = AppStyle.maxWidth(context);
    final gap = AppStyle.cardGap(context, w);

    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpgradeHeader(padding: padding),
              SizedBox(height: gap),
              PlansSection(padding: padding * 1.5),
            ],
          ),
        ),
      ),
    );
  }
}
