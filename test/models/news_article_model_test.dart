import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/news_article_model.dart';
import 'package:zentriq/domain/entities/news_article.dart';

void main() {
  group('NewsArticleModel', () {
    final testNewsArticle = NewsArticleModel(
      id: '1',
      title: 'Test Article',
      content: 'This is test content',
      summary: 'Test summary',
      author: 'Test Author',
      source: 'Test Source',
      url: 'https://test.com',
      imageUrl: 'https://test.com/image.jpg',
      publishedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      category: NewsCategory.defi,
      tags: ['test', 'article'],
      readTime: 5,
      isBookmarked: false,
      isRead: true,
    );

    const testJson = {
      'id': '1',
      'title': 'Test Article',
      'content': 'This is test content',
      'summary': 'Test summary',
      'author': 'Test Author',
      'source': 'Test Source',
      'url': 'https://test.com',
      'image_url': 'https://test.com/image.jpg',
      'published_at': '2023-01-01T00:00:00.000Z',
      'category': 'defi',
      'tags': ['test', 'article'],
      'read_time': 5,
      'is_bookmarked': false,
      'is_read': true,
    };

    test('should create NewsArticleModel from JSON', () {
      // Act
      final result = NewsArticleModel.fromJson(testJson);

      // Assert
      expect(result.id, '1');
      expect(result.title, 'Test Article');
      expect(result.content, 'This is test content');
      expect(result.summary, 'Test summary');
      expect(result.author, 'Test Author');
      expect(result.source, 'Test Source');
      expect(result.url, 'https://test.com');
      expect(result.imageUrl, 'https://test.com/image.jpg');
      expect(result.publishedAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(result.category, NewsCategory.defi);
      expect(result.tags, ['test', 'article']);
      expect(result.readTime, 5);
      expect(result.isBookmarked, false);
      expect(result.isRead, true);
    });

    test('should create NewsArticleModel from JSON with minimal data', () {
      // Arrange
      const minimalJson = {
        'id': '2',
        'title': 'Minimal Article',
        'content': 'Minimal content',
        'summary': 'Minimal summary',
        'author': 'Minimal Author',
        'source': 'Minimal Source',
        'url': 'https://minimal.com',
        'image_url': 'https://minimal.com/image.jpg',
        'published_at': '2023-01-01T00:00:00.000Z',
        'category': 'general',
        'tags': [],
      };

      // Act
      final result = NewsArticleModel.fromJson(minimalJson);

      // Assert
      expect(result.id, '2');
      expect(result.title, 'Minimal Article');
      expect(result.category, NewsCategory.general);
      expect(result.tags, []);
      expect(result.readTime, null);
      expect(result.isBookmarked, null);
      expect(result.isRead, null);
    });

    test('should convert NewsArticleModel to JSON', () {
      // Act
      final result = testNewsArticle.toJson();

      // Assert
      expect(result['id'], '1');
      expect(result['title'], 'Test Article');
      expect(result['content'], 'This is test content');
      expect(result['summary'], 'Test summary');
      expect(result['author'], 'Test Author');
      expect(result['source'], 'Test Source');
      expect(result['url'], 'https://test.com');
      expect(result['image_url'], 'https://test.com/image.jpg');
      expect(result['published_at'], '2023-01-01T00:00:00.000Z');
      expect(result['category'], 'defi');
      expect(result['tags'], ['test', 'article']);
      expect(result['read_time'], 5);
      expect(result['is_bookmarked'], false);
      expect(result['is_read'], true);
    });

    test('should create NewsArticleModel from NewsArticle entity', () {
      // Arrange
      final entity = NewsArticle(
        id: '3',
        title: 'Entity Article',
        content: 'Entity content',
        summary: 'Entity summary',
        author: 'Entity Author',
        source: 'Entity Source',
        url: 'https://entity.com',
        imageUrl: 'https://entity.com/image.jpg',
        publishedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        category: NewsCategory.nft,
        tags: ['entity', 'test'],
        readTime: 3,
        isBookmarked: true,
        isRead: false,
      );

      // Act
      final result = NewsArticleModel.fromEntity(entity);

      // Assert
      expect(result.id, '3');
      expect(result.title, 'Entity Article');
      expect(result.content, 'Entity content');
      expect(result.summary, 'Entity summary');
      expect(result.author, 'Entity Author');
      expect(result.source, 'Entity Source');
      expect(result.url, 'https://entity.com');
      expect(result.imageUrl, 'https://entity.com/image.jpg');
      expect(result.publishedAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(result.category, NewsCategory.nft);
      expect(result.tags, ['entity', 'test']);
      expect(result.readTime, 3);
      expect(result.isBookmarked, true);
      expect(result.isRead, false);
    });

    test('should handle unknown category with default value', () {
      // Arrange
      const jsonWithUnknownCategory = {
        'id': '4',
        'title': 'Unknown Category Article',
        'content': 'Content',
        'summary': 'Summary',
        'author': 'Author',
        'source': 'Source',
        'url': 'https://test.com',
        'image_url': 'https://test.com/image.jpg',
        'published_at': '2023-01-01T00:00:00.000Z',
        'category': 'unknown_category',
        'tags': [],
      };

      // Act
      final result = NewsArticleModel.fromJson(jsonWithUnknownCategory);

      // Assert
      expect(result.category, NewsCategory.general);
    });
  });
}
