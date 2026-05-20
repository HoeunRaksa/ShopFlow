import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:newprovider/feature/search/data/model/SearchHistory.dart';
import '../../data/service/SearchHistoryService.dart';
final isSubmitControllerProvider = StateProvider<bool>((ref) => false);
final searchTextProvider = StateProvider<String>((ref) => '');
final searchControllerProvider =
    AsyncNotifierProvider<SearchController, List<SearchHistory>>(
      SearchController.new,
    );
class SearchController extends AsyncNotifier<List<SearchHistory>> {
  @override
  Future<List<SearchHistory>> build() async {
    final SearchHistoryService service;
    service = ref.read(searchServiceProvider);
    return service.getHistory();
  }
  Future<void> clearHistory() async {
    final service = ref.read(searchServiceProvider);
    await service.clearHistory();
    ref.invalidateSelf();
  }
  Future<void> removeItem(String keyword) async {
    final service = ref.read(searchServiceProvider);
    await service.removeItem(keyword);
    ref.invalidateSelf();
  }
  Future<void> saveSearch(String keyword) async {
    final service = ref.read(searchServiceProvider);
    await service.saveSearch(keyword);
    ref.invalidateSelf();
  }
}
