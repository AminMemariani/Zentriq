import '../../../../core/utils/result.dart';

/// Abstract interface for news operations
abstract class NewsServiceInterface {
  /// Fetches news from NewsAPI
  Future<Result<List<Map<String, dynamic>>>> getNewsFromNewsAPI({
    String query = 'Algorand OR blockchain OR cryptocurrency',
    int pageSize = 20,
    String language = 'en',
    String sortBy = 'publishedAt',
  });

  /// Fetches crypto news from CryptoCompare
  Future<Result<List<Map<String, dynamic>>>> getCryptoNewsFromCryptoCompare({
    String category = 'general',
    int limit = 20,
  });

  /// Fetches RSS feed and parses it
  Future<Result<List<Map<String, dynamic>>>> getRSSFeed(String rssUrl);

  /// Fetches Algorand Foundation news
  Future<Result<List<Map<String, dynamic>>>> getAlgorandFoundationNews();

  /// Fetches CoinDesk news
  Future<Result<List<Map<String, dynamic>>>> getCoinDeskNews();

  /// Fetches CoinTelegraph news
  Future<Result<List<Map<String, dynamic>>>> getCoinTelegraphNews();

  /// Fetches all Algorand-related news from multiple sources
  Future<Result<List<Map<String, dynamic>>>> getAllAlgorandNews();

  /// Fetches trending crypto news
  Future<Result<List<Map<String, dynamic>>>> getTrendingCryptoNews();

  /// Searches for news articles
  Future<Result<List<Map<String, dynamic>>>> searchNews(
    String query, {
    int limit = 20,
  });

  /// Fetches news by category
  Future<Result<List<Map<String, dynamic>>>> getNewsByCategory(
    String category, {
    int limit = 20,
  });

  /// Formats date for display
  String formatDate(DateTime date);

  /// Cleans HTML from description
  String cleanHtml(String html);

  /// Extracts image URL from content
  String? extractImageUrl(String content);

  /// Estimates reading time for an article
  int estimateReadingTime(String content);
}
