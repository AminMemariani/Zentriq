import '../entities/news_article.dart';
import '../repositories/news_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for getting latest news
class GetLatestNewsParams {
  const GetLatestNewsParams({this.limit = 20});

  final int limit;
}

/// Use case for getting latest news articles
class GetLatestNews extends UseCase<List<NewsArticle>, GetLatestNewsParams> {
  GetLatestNews(this._repository);

  final NewsRepository _repository;

  @override
  Future<Result<List<NewsArticle>>> call(GetLatestNewsParams params) {
    return _repository.getLatestNews(limit: params.limit);
  }
}
