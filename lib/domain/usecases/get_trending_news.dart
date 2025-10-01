import '../entities/news_article.dart';
import '../repositories/news_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for getting trending news
class GetTrendingNewsParams {
  const GetTrendingNewsParams({this.limit = 10});

  final int limit;
}

/// Use case for getting trending news articles
class GetTrendingNews
    extends UseCase<List<NewsArticle>, GetTrendingNewsParams> {
  GetTrendingNews(this._repository);

  final NewsRepository _repository;

  @override
  Future<Result<List<NewsArticle>>> call(GetTrendingNewsParams params) {
    return _repository.getTrendingNews(limit: params.limit);
  }
}
