import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/core/app_style.dart';
import 'package:newprovider/feature/upgradePlan/presentation/widgets/plan_payment_form.dart';
import 'package:newprovider/shared/app_custom_appBar.dart';

import '../../../../shared/app_bar_icon_button.dart';
import '../../../../shared/app_scaffold.dart';
import '../state/subscriptionPlanEntryControllerprovider.dart';

class PlanPaymentView extends ConsumerWidget {
  final int subscriptionId;
  const PlanPaymentView({super.key, required this.subscriptionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = AppStyle.screenWidth(context);
    final bodySize = AppStyle.bodySize(context,w);
    final space = AppStyle.bottomSpace(context,w);
    final subscription = ref.watch(
      subscriptionPlanTypeProvider(subscriptionId),
    );
    return AppScaffold(
      appBar: AppCustomAppBar(title: "Payment details"),
      body:  SingleChildScrollView(
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
    );
  }
}
