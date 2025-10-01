import '../entities/token.dart';
import '../repositories/token_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Use case for getting all tokens
class GetAllTokens extends UseCaseNoParams<List<Token>> {
  GetAllTokens(this._repository);

  final TokenRepository _repository;

  @override
  Future<Result<List<Token>>> call() {
    return _repository.getAllTokens();
  }
}
