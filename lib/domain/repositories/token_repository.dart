import '../entities/token.dart';
import '../../core/utils/result.dart';

/// Abstract repository for token-related operations
abstract class TokenRepository {
  /// Gets all tokens
  Future<Result<List<Token>>> getAllTokens();

  /// Gets top performing tokens
  Future<Result<List<Token>>> getTopPerformers({int limit = 10});

  /// Gets token by symbol
  Future<Result<Token>> getTokenBySymbol(String symbol);

  /// Gets token by ID
  Future<Result<Token>> getTokenById(String id);

  /// Refreshes token data
  Future<Result<List<Token>>> refreshTokens();

  /// Gets tokens sorted by market cap
  Future<Result<List<Token>>> getTokensByMarketCap({int limit = 50});

  /// Gets tokens sorted by volume
  Future<Result<List<Token>>> getTokensByVolume({int limit = 50});
}
