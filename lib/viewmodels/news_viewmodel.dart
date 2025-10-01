import 'package:flutter/foundation.dart';
import '../domain/entities/news_article.dart';
import '../domain/usecases/get_latest_news.dart';
import '../domain/usecases/get_trending_news.dart';
import '../core/errors/failures.dart' as failures;

/// ViewModel for news-related operations using Provider
class NewsViewModel extends ChangeNotifier {
  NewsViewModel(this._getLatestNews, this._getTrendingNews);

  final GetLatestNews _getLatestNews;
  final GetTrendingNews _getTrendingNews;

  // News state
  List<NewsArticle> _latestNews = [];
  List<NewsArticle> _trendingNews = [];
  bool _isLoadingLatestNews = false;
  bool _isLoadingTrendingNews = false;
  String? _latestNewsErrorMessage;
  String? _trendingNewsErrorMessage;

  // Filter state
  NewsCategory? _selectedCategory;
  String _searchQuery = '';

  // Getters
  List<NewsArticle> get latestNews => _latestNews;
  List<NewsArticle> get trendingNews => _trendingNews;
  bool get isLoadingLatestNews => _isLoadingLatestNews;
  bool get isLoadingTrendingNews => _isLoadingTrendingNews;
  String? get latestNewsErrorMessage => _latestNewsErrorMessage;
  String? get trendingNewsErrorMessage => _trendingNewsErrorMessage;
  bool get hasLatestNewsError => _latestNewsErrorMessage != null;
  bool get hasTrendingNewsError => _trendingNewsErrorMessage != null;
  NewsCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Loads latest news articles
  Future<void> loadLatestNews({int limit = 20}) async {
    _setLatestNewsLoading(true);
    _clearLatestNewsError();

    final params = GetLatestNewsParams(limit: limit);
    final result = await _getLatestNews(params);

    result
        .onSuccess((articles) {
          _latestNews = articles;
          notifyListeners();
        })
        .onFailure((failure) {
          _setLatestNewsError(_getErrorMessage(failure));
        });

    _setLatestNewsLoading(false);
  }

  /// Loads trending news articles
  Future<void> loadTrendingNews({int limit = 10}) async {
    _setTrendingNewsLoading(true);
    _clearTrendingNewsError();

    final params = GetTrendingNewsParams(limit: limit);
    final result = await _getTrendingNews(params);

    result
        .onSuccess((articles) {
          _trendingNews = articles;
          notifyListeners();
        })
        .onFailure((failure) {
          _setTrendingNewsError(_getErrorMessage(failure));
        });

    _setTrendingNewsLoading(false);
  }

  /// Refreshes all news data
  Future<void> refreshNews() async {
    await Future.wait([loadLatestNews(), loadTrendingNews()]);
  }

  /// Sets the selected category filter
  void setCategoryFilter(NewsCategory? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// Sets the search query
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Clears all filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Gets filtered news articles based on current filters
  List<NewsArticle> getFilteredNews() {
    List<NewsArticle> filteredNews = List.from(_latestNews);

    // Apply category filter
    if (_selectedCategory != null) {
      filteredNews = filteredNews
          .where((article) => article.category == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      filteredNews = filteredNews.where((article) {
        return article.title.toLowerCase().contains(lowercaseQuery) ||
            article.content.toLowerCase().contains(lowercaseQuery) ||
            article.summary.toLowerCase().contains(lowercaseQuery) ||
            article.tags.any(
              (tag) => tag.toLowerCase().contains(lowercaseQuery),
            );
      }).toList();
    }

    return filteredNews;
  }

  /// Gets news articles by category
  List<NewsArticle> getNewsByCategory(NewsCategory category) {
    return _latestNews
        .where((article) => article.category == category)
        .toList();
  }

  /// Gets breaking news articles
  List<NewsArticle> getBreakingNews() {
    return _latestNews.where((article) => article.isBreakingNews).toList();
  }

  /// Gets recent news articles (within 24 hours)
  List<NewsArticle> getRecentNews() {
    return _latestNews.where((article) => article.isRecent).toList();
  }

  /// Gets bookmarked news articles
  List<NewsArticle> getBookmarkedNews() {
    return _latestNews
        .where((article) => article.isBookmarked == true)
        .toList();
  }

  /// Gets unread news articles
  List<NewsArticle> getUnreadNews() {
    return _latestNews.where((article) => article.isRead != true).toList();
  }

  /// Searches news articles by query
  List<NewsArticle> searchNews(String query) {
    if (query.isEmpty) return _latestNews;

    final lowercaseQuery = query.toLowerCase();
    return _latestNews.where((article) {
      return article.title.toLowerCase().contains(lowercaseQuery) ||
          article.content.toLowerCase().contains(lowercaseQuery) ||
          article.summary.toLowerCase().contains(lowercaseQuery) ||
          article.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  /// Gets news article by ID
  NewsArticle? getNewsById(String id) {
    try {
      return _latestNews.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets category statistics
  Map<NewsCategory, int> getCategoryStats() {
    final stats = <NewsCategory, int>{};
    for (final category in NewsCategory.values) {
      stats[category] = _latestNews
          .where((article) => article.category == category)
          .length;
    }
    return stats;
  }

  /// Gets news statistics
  Map<String, dynamic> getNewsStats() {
    final totalArticles = _latestNews.length;
    final breakingNews = _latestNews.where((a) => a.isBreakingNews).length;
    final trendingArticles = _latestNews.where((a) => a.isTrending).length;
    final bookmarkedArticles = _latestNews
        .where((a) => a.isBookmarked == true)
        .length;
    final unreadArticles = _latestNews.where((a) => a.isRead != true).length;

    return {
      'totalArticles': totalArticles,
      'breakingNews': breakingNews,
      'trendingArticles': trendingArticles,
      'bookmarkedArticles': bookmarkedArticles,
      'unreadArticles': unreadArticles,
    };
  }

  /// Gets featured articles (trending and recent)
  List<NewsArticle> getFeaturedArticles({int limit = 5}) {
    final featuredArticles = <NewsArticle>[];

    // Add breaking news first
    featuredArticles.addAll(_latestNews.where((a) => a.isBreakingNews).take(2));

    // Add trending articles
    featuredArticles.addAll(
      _latestNews
          .where((a) => a.isTrending && !featuredArticles.contains(a))
          .take(2),
    );

    // Add recent articles
    featuredArticles.addAll(
      _latestNews
          .where((a) => a.isRecent && !featuredArticles.contains(a))
          .take(1),
    );

    return featuredArticles.take(limit).toList();
  }

  /// Gets articles by time period
  List<NewsArticle> getArticlesByTimePeriod({int hours = 24}) {
    final cutoffTime = DateTime.now().subtract(Duration(hours: hours));
    return _latestNews
        .where((article) => article.publishedAt.isAfter(cutoffTime))
        .toList();
  }

  /// Gets most popular tags
  List<String> getPopularTags({int limit = 10}) {
    final tagCounts = <String, int>{};

    for (final article in _latestNews) {
      for (final tag in article.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTags.take(limit).map((e) => e.key).toList();
  }

  // Private methods for state management
  void _setLatestNewsLoading(bool loading) {
    _isLoadingLatestNews = loading;
    notifyListeners();
  }

  void _setLatestNewsError(String message) {
    _latestNewsErrorMessage = message;
    notifyListeners();
  }

  void _clearLatestNewsError() {
    _latestNewsErrorMessage = null;
  }

  void _setTrendingNewsLoading(bool loading) {
    _isLoadingTrendingNews = loading;
    notifyListeners();
  }

  void _setTrendingNewsError(String message) {
    _trendingNewsErrorMessage = message;
    notifyListeners();
  }

  void _clearTrendingNewsError() {
    _trendingNewsErrorMessage = null;
  }

  /// Converts a failure to a user-friendly error message
  String _getErrorMessage(failures.Failure failure) {
    switch (failure.runtimeType) {
      case failures.NetworkFailure _:
        return 'No internet connection. Please check your network.';
      case failures.ServerFailure _:
        return 'Server error. Please try again later.';
      case failures.CacheFailure _:
        return 'Failed to load data from cache.';
      case failures.ValidationFailure _:
        return 'Invalid data. Please check your input.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
