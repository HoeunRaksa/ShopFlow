import 'package:shared_preferences/shared_preferences.dart';

class PlanService {
  static const String _key = "plan";

  static const validPlans = [
    "free",
    "premium member",
    "ultimate",
  ];

  Future<void> savePlan(String plan) async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      plan.toLowerCase(),
    );
  }

  Future<String> getPlan() async {
    final prefs =
    await SharedPreferences.getInstance();

    final plan =
    prefs.getString(_key);

    if (plan == null ||
        !validPlans.contains(plan)) {
      return "free";
    }

    return plan;
  }

  Future<void> clearPlan() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}