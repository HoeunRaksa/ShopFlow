import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final currentPlanProvider =
StateNotifierProvider<CurrentPlanController, String>(
      (ref) => CurrentPlanController(),
);

class CurrentPlanController extends StateNotifier<String> {
  static const String _key = "plan";

  CurrentPlanController() : super("free") {
    loadPlan();
  }

  Future<void> loadPlan() async {
    final prefs = await SharedPreferences.getInstance();

    state =
        prefs.getString(_key)?.toLowerCase().trim() ??
            "free";
  }

  Future<void> changePlan(String plan) async {
    final prefs = await SharedPreferences.getInstance();

    final normalizedPlan =
    plan.toLowerCase().trim();

    await prefs.setString(
      _key,
      normalizedPlan,
    );

    state = normalizedPlan;
  }

  Future<void> clearPlan() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);

    state = "free";
  }
}