import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart' as failures;
import 'interfaces/news_service_interface.dart';

/// News service for fetching crypto and Algorand news from various sources
class NewsService implements NewsServiceInterface {
  NewsService({this.newsApiKey, this.cryptoCompareApiKey});

  final String? newsApiKey;
  final String? cryptoCompareApiKey;

  // Base URLs for different news APIs
  static const String _newsApiBaseUrl = 'https://newsapi.org/v2';
  static const String _cryptoCompareBaseUrl =
      'https://min-api.cryptocompare.com/data/v2';
  static const String _algorandFoundationRss =
      'https://algorand.foundation/news/rss.xml';
  static const String _coindeskRss =
      'https://www.coindesk.com/arc/outboundfeeds/rss/';
  static const String _cointelegraphRss = 'https://cointelegraph.com/rss';

  /// Headers for NewsAPI
  Map<String, String> get _newsApiHeaders => {
    'Content-Type': 'application/json',
    if (newsApiKey != null) 'X-API-Key': newsApiKey!,
  };

  /// Headers for CryptoCompare
  Map<String, String> get _cryptoCompareHeaders => {
    'Content-Type': 'application/json',
    if (cryptoCompareApiKey != null)
      'authorization': 'Apikey $cryptoCompareApiKey',
  };

  /// Fetches news from NewsAPI
  @override
  Future<Result<List<Map<String, dynamic>>>> getNewsFromNewsAPI({
    String query = 'Algorand OR blockchain OR cryptocurrency',
    int pageSize = 20,
    String language = 'en',
    String sortBy = 'publishedAt',
  }) async {
    try {
      final url = Uri.parse(
        '$_newsApiBaseUrl/everything?q=$query&pageSize=$pageSize&language=$language&sortBy=$sortBy',
      );
      final response = await http.get(url, headers: _newsApiHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final articles =
            (data['articles'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>() ??
            [];
        return Result.success(articles);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch news from NewsAPI: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches crypto news from CryptoCompare
  @override
  Future<Result<List<Map<String, dynamic>>>> getCryptoNewsFromCryptoCompare({
    String category = 'general',
    int limit = 20,
  }) async {
    try {
      final url = Uri.parse(
        '$_cryptoCompareBaseUrl/news/?lang=EN&categories=$category&limit=$limit',
      );
      final response = await http.get(url, headers: _cryptoCompareHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final news =
            (data['Data'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            [];
        return Result.success(news);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch crypto news: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches RSS feed and parses it
  @override
  Future<Result<List<Map<String, dynamic>>>> getRSSFeed(String rssUrl) async {
    try {
      final url = Uri.parse(rssUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        final articles = items.map((item) {
          return {
            'title': item.findElements('title').first.innerText,
            'description': item.findElements('description').first.innerText,
            'link': item.findElements('link').first.innerText,
            'pubDate': item.findElements('pubDate').first.innerText,
            'source': _extractSourceFromUrl(rssUrl),
          };
        }).toList();

        return Result.success(articles);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch RSS feed: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches Algorand Foundation news
  @override
  Future<Result<List<Map<String, dynamic>>>> getAlgorandFoundationNews() async {
    return getRSSFeed(_algorandFoundationRss);
  }

  /// Fetches CoinDesk news
  @override
  Future<Result<List<Map<String, dynamic>>>> getCoinDeskNews() async {
    return getRSSFeed(_coindeskRss);
  }

  /// Fetches CoinTelegraph news
  @override
  Future<Result<List<Map<String, dynamic>>>> getCoinTelegraphNews() async {
    return getRSSFeed(_cointelegraphRss);
  }

  /// Fetches all Algorand-related news from multiple sources
  @override
  Future<Result<List<Map<String, dynamic>>>> getAllAlgorandNews() async {
    try {
      final results = await Future.wait([
        getAlgorandFoundationNews(),
        getNewsFromNewsAPI(query: 'Algorand', pageSize: 10),
        getCryptoNewsFromCryptoCompare(category: 'general', limit: 10),
      ]);

      final allNews = <Map<String, dynamic>>[];

      for (final result in results) {
        if (result.isSuccess) {
          allNews.addAll(result.data!);
        } else {
          // Log error but continue with other sources
          // TODO: Use proper logging instead of print
          // print('Failed to fetch news from one source: ${result.failure}');
        }
      }

      // Sort by date (newest first)
      allNews.sort((a, b) {
        final dateA = _parseDate(a['pubDate'] ?? a['publishedAt'] ?? '');
        final dateB = _parseDate(b['pubDate'] ?? b['publishedAt'] ?? '');
        return dateB.compareTo(dateA);
      });

      return Result.success(allNews);
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches trending crypto news
  @override
  Future<Result<List<Map<String, dynamic>>>> getTrendingCryptoNews() async {
    try {
      final results = await Future.wait([
        getCryptoNewsFromCryptoCompare(category: 'general', limit: 15),
        getNewsFromNewsAPI(
          query: 'cryptocurrency OR bitcoin OR ethereum',
          pageSize: 15,
        ),
      ]);

      final allNews = <Map<String, dynamic>>[];

      for (final result in results) {
        if (result.isSuccess) {
          allNews.addAll(result.data!);
        } else {
          // TODO: Use proper logging instead of print
          // print('Failed to fetch trending news from one source: ${result.failure}');
        }
      }

      // Sort by date and add trending score
      allNews.sort((a, b) {
        final dateA = _parseDate(a['pubDate'] ?? a['publishedAt'] ?? '');
        final dateB = _parseDate(b['pubDate'] ?? b['publishedAt'] ?? '');
        return dateB.compareTo(dateA);
      });

      return Result.success(allNews);
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Searches for news articles
  @override
  Future<Result<List<Map<String, dynamic>>>> searchNews(
    String query, {
    int limit = 20,
  }) async {
    try {
      final results = await Future.wait([
        getNewsFromNewsAPI(query: query, pageSize: limit ~/ 2),
        getCryptoNewsFromCryptoCompare(limit: limit ~/ 2),
      ]);

      final allNews = <Map<String, dynamic>>[];

      for (final result in results) {
        if (result.isSuccess) {
          final news = result.data!;
          // Filter news that matches the query
          final filteredNews = news.where((article) {
            final title = (article['title'] ?? '').toString().toLowerCase();
            final description = (article['description'] ?? '')
                .toString()
                .toLowerCase();
            final queryLower = query.toLowerCase();
            return title.contains(queryLower) ||
                description.contains(queryLower);
          }).toList();
          allNews.addAll(filteredNews);
        } else {
          // TODO: Use proper logging instead of print
          // print('Failed to search news from one source: ${result.failure}');
        }
      }

      // Sort by date
      allNews.sort((a, b) {
        final dateA = _parseDate(a['pubDate'] ?? a['publishedAt'] ?? '');
        final dateB = _parseDate(b['pubDate'] ?? b['publishedAt'] ?? '');
        return dateB.compareTo(dateA);
      });

      return Result.success(allNews.take(limit).toList());
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches news by category
  @override
  Future<Result<List<Map<String, dynamic>>>> getNewsByCategory(
    String category, {
    int limit = 20,
  }) async {
    try {
      String query;
      switch (category.toLowerCase()) {
        case 'defi':
          query = 'DeFi OR decentralized finance OR yield farming';
          break;
        case 'nft':
          query = 'NFT OR non-fungible token OR digital collectible';
          break;
        case 'governance':
          query =
              'governance OR voting OR DAO OR decentralized autonomous organization';
          break;
        case 'technology':
          query = 'blockchain technology OR smart contract OR protocol';
          break;
        case 'market':
          query = 'cryptocurrency market OR price analysis OR trading';
          break;
        case 'regulation':
          query = 'cryptocurrency regulation OR SEC OR legal';
          break;
        default:
          query = 'cryptocurrency OR blockchain';
      }

      return getNewsFromNewsAPI(query: query, pageSize: limit);
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Extracts source name from RSS URL
  String _extractSourceFromUrl(String url) {
    if (url.contains('algorand.foundation')) return 'Algorand Foundation';
    if (url.contains('coindesk')) return 'CoinDesk';
    if (url.contains('cointelegraph')) return 'CoinTelegraph';
    return 'RSS Feed';
  }

  /// Parses date string to DateTime
  DateTime _parseDate(String dateString) {
    try {
      // This is a simplified date parsing - in a real app you'd use intl package
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Formats date for display
  @override
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Cleans HTML from description
  @override
  String cleanHtml(String html) {
    // Simple HTML tag removal - in a real app you'd use html package
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }

  /// Extracts image URL from content
  @override
  String? extractImageUrl(String content) {
    final imageRegex = RegExp(r'<img[^>]+src="([^"]+)"');
    final match = imageRegex.firstMatch(content);
    return match?.group(1);
  }

  /// Estimates reading time for an article
  @override
  int estimateReadingTime(String content) {
    final wordsPerMinute = 200;
    final wordCount = content.split(' ').length;
    return (wordCount / wordsPerMinute).ceil();
  }
}
