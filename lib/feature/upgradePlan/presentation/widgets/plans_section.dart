import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newprovider/feature/upgradePlan/presentation/widgets/plan_card.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';
import '../state/save_plan_controller_provider.dart';
import '../state/subscriptionPlanEntryControllerprovider.dart';

class PlansSection extends ConsumerStatefulWidget {
  final double padding;

  const PlansSection({
    super.key,
    required this.padding,
  });

  @override
  ConsumerState<PlansSection> createState() => _PlansSection();
}

class _PlansSection extends ConsumerState<PlansSection> {
  int getPlanLevel(String plan) {
    switch (plan.toLowerCase().trim()) {
      case "ultimate":
        return 3;

      case "premium":
      case "premium member":
        return 2;

      default:
        return 1;
    }
  }

  bool canUsePlan(String currentPlan, String plan) {
    return getPlanLevel(currentPlan) >= getPlanLevel(plan);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userControllerProvider).value;

    final springPlan =
        user?.subscription?.plan.toLowerCase().trim() ?? "free";

    final selectedPlan =
    ref.watch(currentPlanProvider).toLowerCase().trim();

    final subscriptionPlan = ref.watch(subscriptionPlanEntryProvider);

    debugPrint("SPRING PLAN: $springPlan");
    debugPrint("SELECTED PLAN FROM LOCAL: $selectedPlan");

    return subscriptionPlan.when(
      data: (plans) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            plans.length,
                (index) {
              final plan = plans[index];

              final planName =
              plan.title.toLowerCase().trim();

              final canUse =
              canUsePlan(springPlan, planName);

              final selected =
                  selectedPlan == planName;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: widget.padding,
                ),
                child: PlanCard(
                  title: plan.title,
                  price: "\$${plan.price}",
                  description: plan.description,
                  features: plan.features
                      .map((e) => e.feature)
                      .toList(),

                  // selected model from SharedPreferences
                  isCurrent: selected,

                  buttonText: canUse
                      ? selected
                      ? "Selected"
                      : "Use"
                      : "Upgrade to ${plan.title}",

                  onTap: () {
                    if (canUse) {
                      ref
                          .read(currentPlanProvider.notifier)
                          .changePlan(planName);
                    } else {
                      context.push(
                        "/payment-view/${plan.id}",
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (e, s) {
        return Center(
          child: Text(
            e.toString(),
          ),
        );
      },
    );
  }
}