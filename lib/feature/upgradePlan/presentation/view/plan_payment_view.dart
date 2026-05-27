import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/upgradePlan/presentation/widgets/plan_payment_form.dart';

import '../../../../shared/app_bar_icon_button.dart';
import '../state/subscriptionPlanEntryControllerprovider.dart';

class PlanPaymentView extends ConsumerWidget {
  final int subscriptionId;
  const PlanPaymentView({super.key, required this.subscriptionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final w = AppStyle.screenWidth(context);
    final iconSize = AppStyle.iconSize(context, w);
    final padding = AppStyle.padding(context, w);
    final bodySize = AppStyle.bodySize(context,w);
    final space = AppStyle.bottomSpace(context,w);
    final subscription = ref.watch(
      subscriptionPlanTypeProvider(subscriptionId),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Row(
          children: [
            AppBarIconButton(
              onPressed: () {context.pop();},
              icon: Icons.arrow_back,
              iconSize: iconSize * 1.5,
              filled: true,
              color: theme.colorScheme.primary,
            ),
            Text("Payment details", style: TextStyle(color: theme.colorScheme.onSurface),),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: space * 0.3,),
              Text("Enter your card information to subscribe", style: TextStyle(fontSize: bodySize),),
              SizedBox(height: space * 0.5,),
              Center(
                child: subscription != null
                    ? PlanPaymentForm(subscriptionPlanResponse: subscription)
                    : CircularProgressIndicator(),
              ),

            ],
          ),
        )
      )
    );
  }
}
