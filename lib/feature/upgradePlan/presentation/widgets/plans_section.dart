import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newprovider/feature/upgradePlan/presentation/widgets/plan_card.dart';
import 'package:newprovider/feature/user_profile/presentation/state/user_contoller.dart';

import '../../../../core/app_style.dart';
import '../state/plan_controller_provider.dart';

class PlansSection extends ConsumerWidget {
  const PlansSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gap = AppStyle.cardGap(context);

    final user = ref.watch(userControllerProvider).value;

    final userPlan =
        user?.subscription?.plan.toLowerCase() ?? "free";

    bool canUsePlan(String currentPlan, String plan) {
      final currentLevel = switch (currentPlan.toLowerCase()) {
        "ultimate" => 3,
        "premium member" => 2,
        "premium" => 2,
        _ => 1,
      };

      final planLevel = switch (plan.toLowerCase()) {
        "ultimate" => 3,
        "premium member" => 2,
        "premium" => 2,
        _ => 1,
      };

      return currentLevel >= planLevel;
    }

    final selectedPlan = ref.watch(currentPlanProvider);

    final canUseFree = canUsePlan(userPlan, "free");
    final canUsePremium = canUsePlan(userPlan, "premium member");
    final canUseUltimate = canUsePlan(userPlan, "ultimate");

    final bool isFree = selectedPlan == "free";
    final bool isPremium = selectedPlan == "premium member";
    final bool isUltimate = selectedPlan == "ultimate";

    return Column(
      children: [
        PlanCard(
          title: "Free",
          price: "\$0",
          description: "Basic access for normal users.",
          features: const [
            "Browse products",
            "Add to cart",
            "Basic account features",
          ],
          buttonText: isFree ? "Current Plan" : "Use",
          isCurrent: isFree,
          onTap: () {
            ref.read(currentPlanProvider.notifier).changePlan("free");
          },
        ),

        SizedBox(height: gap),

        PlanCard(
          title: "Premium Member",
          price: "\$4.99",
          description: "Best for users who want more features.",
          features: const [
            "All Free features",
            "Priority support",
            "Special member benefits",
          ],
          buttonText: isPremium
              ? "Current Plan"
              : canUsePremium
              ? "Use"
              : "Upgrade to Premium",
          isCurrent: isPremium,
          onTap: () {
            ref
                .read(currentPlanProvider.notifier)
                .changePlan("premium member");
          },
        ),

        SizedBox(height: gap),

        PlanCard(
          title: "Ultimate",
          price: "\$9.99",
          description: "Full access with the best experience.",
          features: const [
            "All Premium features",
            "Highest priority support",
            "Exclusive ultimate benefits",
          ],
          buttonText: isUltimate
              ? "Current Plan"
              : canUseUltimate
              ? "Use"
              : "Upgrade to Ultimate",
          isHighlighted: true,
          isCurrent: isUltimate,
          onTap: () {
            ref.read(currentPlanProvider.notifier).changePlan("ultimate");
          },
        ),
      ],
    );
  }
}