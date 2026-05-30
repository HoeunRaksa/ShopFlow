import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_style.dart';
import '../../../../shared/app_scaffold.dart';
import '../widgets/plans_section.dart';
import '../widgets/update_header.dart';

class UpgradeView extends ConsumerWidget {
  const UpgradeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final maxWidth = AppStyle.maxWidth(context);
    return AppScaffold(
      usePadding: false,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpgradeHeader(padding: padding),
                PlansSection(padding: padding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
