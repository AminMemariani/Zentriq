import '../../domain/entities/news_article.dart';

/// News article model for data layer
class NewsArticleModel extends NewsArticle {
  const NewsArticleModel({
    required super.id,
    required super.title,
    required super.content,
    required super.summary,
    required super.author,
    required super.source,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.category,
    required super.tags,
    super.readTime,
    super.isBookmarked,
    super.isRead,
  });

  /// Creates a NewsArticleModel from a JSON map
  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      summary: json['summary'] as String,
      author: json['author'] as String,
      source: json['source'] as String,
      url: json['url'] as String,
      imageUrl: json['image_url'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      category: NewsCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => NewsCategory.general,
      ),
      tags: List<String>.from(json['tags'] as List),
      readTime: json['read_time'] as int?,
      isBookmarked: json['is_bookmarked'] as bool?,
      isRead: json['is_read'] as bool?,
    );
  }

  /// Converts this NewsArticleModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'author': author,
      'source': source,
      'url': url,
      'image_url': imageUrl,
      'published_at': publishedAt.toIso8601String(),
      'category': category.name,
      'tags': tags,
      'read_time': readTime,
      'is_bookmarked': isBookmarked,
      'is_read': isRead,
    };
  }

  /// Creates a NewsArticleModel from a NewsArticle entity
  factory NewsArticleModel.fromEntity(NewsArticle article) {
    return NewsArticleModel(
      id: article.id,
      title: article.title,
      content: article.content,
      summary: article.summary,
      author: article.author,
      source: article.source,
      url: article.url,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      category: article.category,
      tags: article.tags,
      readTime: article.readTime,
      isBookmarked: article.isBookmarked,
      isRead: article.isRead,
    );
  }
}
