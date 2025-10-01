import 'package:equatable/equatable.dart';

/// News article entity representing a news article
class NewsArticle extends Equatable {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.author,
    required this.source,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.category,
    required this.tags,
    this.readTime,
    this.isBookmarked,
    this.isRead,
  });

  final String id;
  final String title;
  final String content;
  final String summary;
  final String author;
  final String source;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final NewsCategory category;
  final List<String> tags;
  final int? readTime;
  final bool? isBookmarked;
  final bool? isRead;

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    summary,
    author,
    source,
    url,
    imageUrl,
    publishedAt,
    category,
    tags,
    readTime,
    isBookmarked,
    isRead,
  ];

  /// Returns formatted published date
  String get formattedPublishedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 7) {
      return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
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

  /// Returns formatted read time
  String get formattedReadTime {
    if (readTime == null) return 'Unknown';
    return '${readTime!} min read';
  }

  /// Returns true if the article is recent (within 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);
    return difference.inHours < 24;
  }

  /// Returns true if the article is trending (recent and has popular tags)
  bool get isTrending {
    return isRecent &&
        tags.any((tag) => _trendingTags.contains(tag.toLowerCase()));
  }

  /// Returns true if the article is breaking news (very recent)
  bool get isBreakingNews {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);
    return difference.inMinutes < 60;
  }

  /// Returns the primary tag (first tag or most relevant)
  String get primaryTag {
    if (tags.isEmpty) return category.displayName;
    return tags.first;
  }

  /// Returns a shortened version of the title for display
  String get shortTitle {
    if (title.length <= 60) return title;
    return '${title.substring(0, 57)}...';
  }

  /// Returns a shortened version of the summary for display
  String get shortSummary {
    if (summary.length <= 120) return summary;
    return '${summary.substring(0, 117)}...';
  }

  /// Trending tags for determining trending articles
  static const List<String> _trendingTags = [
    'algorand',
    'defi',
    'nft',
    'blockchain',
    'cryptocurrency',
    'yieldly',
    'tinyman',
    'opulous',
    'governance',
    'staking',
  ];

  /// Creates a copy of this news article with the given fields replaced with new values
  NewsArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? author,
    String? source,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
    NewsCategory? category,
    List<String>? tags,
    int? readTime,
    bool? isBookmarked,
    bool? isRead,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      author: author ?? this.author,
      source: source ?? this.source,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      readTime: readTime ?? this.readTime,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// News category enum
enum NewsCategory {
  general,
  defi,
  nft,
  governance,
  technology,
  partnerships,
  ecosystem,
  market,
  regulation,
  other,
}

/// Extension to get display names for news categories
extension NewsCategoryExtension on NewsCategory {
  String get displayName {
    switch (this) {
      case NewsCategory.general:
        return 'General';
      case NewsCategory.defi:
        return 'DeFi';
      case NewsCategory.nft:
        return 'NFT';
      case NewsCategory.governance:
        return 'Governance';
      case NewsCategory.technology:
        return 'Technology';
      case NewsCategory.partnerships:
        return 'Partnerships';
      case NewsCategory.ecosystem:
        return 'Ecosystem';
      case NewsCategory.market:
        return 'Market';
      case NewsCategory.regulation:
        return 'Regulation';
      case NewsCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case NewsCategory.general:
        return '📰';
      case NewsCategory.defi:
        return '🏦';
      case NewsCategory.nft:
        return '🎨';
      case NewsCategory.governance:
        return '🗳️';
      case NewsCategory.technology:
        return '⚙️';
      case NewsCategory.partnerships:
        return '🤝';
      case NewsCategory.ecosystem:
        return '🌱';
      case NewsCategory.market:
        return '📈';
      case NewsCategory.regulation:
        return '⚖️';
      case NewsCategory.other:
        return '📄';
    }
  }
}
