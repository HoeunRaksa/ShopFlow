class SearchHistory {
  final String keyword;

  const SearchHistory({
    required this.keyword,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      keyword: json['keyword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
    };
  }
}