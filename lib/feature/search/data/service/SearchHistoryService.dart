import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/SearchHistory.dart';
final searchServiceProvider = Provider((ref) =>
  SearchHistoryService()
);

class SearchHistoryService {
  static const _key = 'search_history';

   Future<void> saveSearch(String keyword) async {
    final prefs = await SharedPreferences.getInstance();

    final history = await getHistory();

    final text = keyword.trim();

    if (text.isEmpty) return;

    history.removeWhere((e) => e.keyword == text);

    history.insert(
      0,
      SearchHistory(keyword: text),
    );

    final limited = history.take(15).toList();

    final encoded = limited
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(_key, encoded);
  }

   Future<List<SearchHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getStringList(_key) ?? [];

    return raw.map((e) {
      return SearchHistory.fromJson(
        jsonDecode(e),
      );
    }).toList();
  }

   Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

   Future<void> removeItem(String keyword) async {
    final prefs = await SharedPreferences.getInstance();

    final history = await getHistory();

    history.removeWhere((e) => e.keyword == keyword);

    final encoded = history
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(_key, encoded);
  }
}