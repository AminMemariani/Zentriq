import '../entities/news_article.dart';
import '../../core/utils/result.dart';

/// Abstract repository for news-related operations
abstract class NewsRepository {
  /// Gets all news articles
  Future<Result<List<NewsArticle>>> getAllNews();

  /// Gets latest news articles
  Future<Result<List<NewsArticle>>> getLatestNews({int limit = 20});

  /// Gets trending news articles
  Future<Result<List<NewsArticle>>> getTrendingNews({int limit = 10});

  /// Gets news articles by category
  Future<Result<List<NewsArticle>>> getNewsByCategory(
    NewsCategory category, {
    int limit = 20,
  });

  /// Gets breaking news articles
  Future<Result<List<NewsArticle>>> getBreakingNews({int limit = 5});

  /// Gets news article by ID
  Future<Result<NewsArticle>> getNewsById(String id);

  /// Searches news articles by query
  Future<Result<List<NewsArticle>>> searchNews(String query, {int limit = 20});

  /// Gets bookmarked news articles
  Future<Result<List<NewsArticle>>> getBookmarkedNews();

  /// Bookmarks a news article
  Future<Result<void>> bookmarkNews(String id);

  /// Removes bookmark from a news article
  Future<Result<void>> removeBookmark(String id);

  /// Marks a news article as read
  Future<Result<void>> markAsRead(String id);

  /// Refreshes news data
  Future<Result<List<NewsArticle>>> refreshNews();
}
