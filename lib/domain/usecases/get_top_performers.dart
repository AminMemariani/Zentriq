import '../entities/token.dart';
import '../repositories/token_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for getting top performers
class GetTopPerformersParams {
  const GetTopPerformersParams({this.limit = 10});

  final int limit;
}

/// Use case for getting top performing tokens
class GetTopPerformers extends UseCase<List<Token>, GetTopPerformersParams> {
  GetTopPerformers(this._repository);

  final TokenRepository _repository;

  @override
  Future<Result<List<Token>>> call(GetTopPerformersParams params) {
    return _repository.getTopPerformers(limit: params.limit);
  }
}
