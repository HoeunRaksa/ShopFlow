import 'package:flutter/material.dart';
import '../../../../core/app_style.dart';
import '../widgets/plans_section.dart';
import '../widgets/update_header.dart';

class UpgradeView extends StatelessWidget {
  const UpgradeView({super.key});

  @override
  Widget build(BuildContext context) {
    final w = AppStyle.screenWidth(context);
    final padding = AppStyle.padding(context, w);
    final maxWidth = AppStyle.maxWidth(context);
    final gap = AppStyle.cardGap(context, w);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const UpgradeHeader(),

                SizedBox(height: gap),

                const PlansSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}