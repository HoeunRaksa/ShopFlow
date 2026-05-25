import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
final currentPlanProvider =
StateNotifierProvider<
    CurrentPlanController,
    String?>(
      (ref) => CurrentPlanController(),
);
class CurrentPlanController
    extends StateNotifier<String?> {

  CurrentPlanController()
      : super("free") {
    loadPlan();
  }

  static const String _key = "plan";

  Future<void> loadPlan() async {
    final prefs =
    await SharedPreferences.getInstance();

    state =
        prefs.getString(_key) ??
            "free";
  }

  Future<void> changePlan(
      String plan,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      plan,
    );

    state = plan;
  }

  Future<void> clearPlan() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(_key);

    state = "free";
  }
}