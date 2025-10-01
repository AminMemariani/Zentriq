import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zentriq/core/errors/failures.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/domain/entities/news_article.dart';
import 'package:zentriq/viewmodels/news_viewmodel.dart';

import '../mocks/mock_repositories.mocks.dart';

void main() {
  group('NewsViewModel', () {
    late NewsViewModel viewModel;
    late MockGetLatestNews mockGetLatestNews;
    late MockGetTrendingNews mockGetTrendingNews;

    setUp(() {
      mockGetLatestNews = MockGetLatestNews();
      mockGetTrendingNews = MockGetTrendingNews();
      viewModel = NewsViewModel(
        mockGetLatestNews,
        mockGetTrendingNews,
      );
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(viewModel.latestNews, isEmpty);
        expect(viewModel.trendingNews, isEmpty);
        expect(viewModel.isLoadingLatestNews, isFalse);
        expect(viewModel.isLoadingTrendingNews, isFalse);
        expect(viewModel.latestNewsErrorMessage, isNull);
        expect(viewModel.trendingNewsErrorMessage, isNull);
        expect(viewModel.selectedCategory, isNull);
        expect(viewModel.searchQuery, isEmpty);
      });
    });

    group('Load Latest News', () {
      test('should load latest news successfully', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Algorand Update',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.ecosystem,
            tags: ['algorand', 'update'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));

        // Act
        await viewModel.loadLatestNews();

        // Assert
        expect(viewModel.latestNews, tNews);
        expect(viewModel.isLoadingLatestNews, false);
        expect(viewModel.latestNewsErrorMessage, isNull);
        verify(mockGetLatestNews.call(any)).called(1);
      });

      test('should handle latest news loading error', () async {
        // Arrange
        final failure = ServerFailure('error');
        provideDummy<Result<List<NewsArticle>>>(Result.failure(failure));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadLatestNews();

        // Assert
        expect(viewModel.latestNews, isEmpty);
        expect(viewModel.isLoadingLatestNews, false);
        expect(viewModel.latestNewsErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetLatestNews.call(any)).called(1);
      });
    });

    group('Load Trending News', () {
      test('should load trending news successfully', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Trending News',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.defi,
            tags: ['defi', 'trending'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetTrendingNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));

        // Act
        await viewModel.loadTrendingNews();

        // Assert
        expect(viewModel.trendingNews, tNews);
        expect(viewModel.isLoadingTrendingNews, false);
        expect(viewModel.trendingNewsErrorMessage, isNull);
        verify(mockGetTrendingNews.call(any)).called(1);
      });

      test('should handle trending news loading error', () async {
        // Arrange
        final failure = NetworkFailure('error');
        provideDummy<Result<List<NewsArticle>>>(Result.failure(failure));
        when(mockGetTrendingNews.call(any))
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadTrendingNews();

        // Assert
        expect(viewModel.trendingNews, isEmpty);
        expect(viewModel.isLoadingTrendingNews, false);
        expect(viewModel.trendingNewsErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetTrendingNews.call(any)).called(1);
      });
    });

    group('Filtering', () {
      test('should filter news by search query', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Algorand Update',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.ecosystem,
            tags: ['algorand', 'update'],
          ),
          NewsArticle(
            id: 'n2',
            title: 'DeFi News',
            content: 'Content 2',
            summary: 'Summary 2',
            author: 'Author 2',
            source: 'Source 2',
            url: 'url2.com',
            imageUrl: 'image2.png',
            publishedAt: DateTime(2023, 1, 2),
            category: NewsCategory.defi,
            tags: ['defi', 'news'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));
        await viewModel.loadLatestNews();

        // Act
        viewModel.setSearchQuery('algorand');
        final filteredNews = viewModel.getFilteredNews();

        // Assert
        expect(filteredNews, [tNews[0]]);
      });

      test('should filter news by category', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Ecosystem News',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.ecosystem,
            tags: ['ecosystem', 'news'],
          ),
          NewsArticle(
            id: 'n2',
            title: 'DeFi News',
            content: 'Content 2',
            summary: 'Summary 2',
            author: 'Author 2',
            source: 'Source 2',
            url: 'url2.com',
            imageUrl: 'image2.png',
            publishedAt: DateTime(2023, 1, 2),
            category: NewsCategory.defi,
            tags: ['defi', 'news'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));
        await viewModel.loadLatestNews();

        // Act
        viewModel.setCategoryFilter(NewsCategory.ecosystem);
        final filteredNews = viewModel.getFilteredNews();

        // Assert
        expect(filteredNews, [tNews[0]]);
      });

      test('should clear filters', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Test News',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.ecosystem,
            tags: ['test', 'news'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));
        await viewModel.loadLatestNews();

        // Set some filters
        viewModel.setCategoryFilter(NewsCategory.ecosystem);
        viewModel.setSearchQuery('test');

        // Act
        viewModel.clearFilters();

        // Assert
        expect(viewModel.selectedCategory, isNull);
        expect(viewModel.searchQuery, isEmpty);
        expect(viewModel.getFilteredNews(), tNews);
      });
    });

    group('Utility Methods', () {
      test('should get news by category', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Governance News',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.governance,
            tags: ['governance', 'news'],
          ),
          NewsArticle(
            id: 'n2',
            title: 'DeFi News',
            content: 'Content 2',
            summary: 'Summary 2',
            author: 'Author 2',
            source: 'Source 2',
            url: 'url2.com',
            imageUrl: 'image2.png',
            publishedAt: DateTime(2023, 1, 2),
            category: NewsCategory.defi,
            tags: ['defi', 'news'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));
        await viewModel.loadLatestNews();

        // Act
        final governanceNews = viewModel.getNewsByCategory(NewsCategory.governance);

        // Assert
        expect(governanceNews, [tNews[0]]);
      });

      test('should get news statistics', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Test News',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.ecosystem,
            tags: ['test', 'news'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));
        await viewModel.loadLatestNews();

        // Act
        final stats = viewModel.getNewsStats();

        // Assert
        expect(stats['totalArticles'], 1);
        expect(stats['breakingNews'], 0);
        expect(stats['trendingArticles'], 0);
      });
    });

    group('Refresh News', () {
      test('should refresh both latest and trending news', () async {
        // Arrange
        final tNews = [
          NewsArticle(
            id: 'n1',
            title: 'Test News',
            content: 'Content 1',
            summary: 'Summary 1',
            author: 'Author 1',
            source: 'Source 1',
            url: 'url1.com',
            imageUrl: 'image1.png',
            publishedAt: DateTime(2023, 1, 1),
            category: NewsCategory.ecosystem,
            tags: ['test', 'news'],
          ),
        ];
        
        provideDummy<Result<List<NewsArticle>>>(Result.success(tNews));
        when(mockGetLatestNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));
        when(mockGetTrendingNews.call(any))
            .thenAnswer((_) async => Result.success(tNews));

        // Act
        await viewModel.refreshNews();

        // Assert
        verify(mockGetLatestNews.call(any)).called(1);
        verify(mockGetTrendingNews.call(any)).called(1);
      });
    });
  });
}
