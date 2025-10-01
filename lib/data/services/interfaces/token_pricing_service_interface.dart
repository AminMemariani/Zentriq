import '../../../../core/utils/result.dart';

/// Abstract interface for token pricing operations
abstract class TokenPricingServiceInterface {
  /// Fetches token price data
  Future<Result<Map<String, dynamic>>> getTokenPrice(String tokenId);

  /// Fetches multiple token prices
  Future<Result<Map<String, dynamic>>> getMultipleTokenPrices(
    List<String> tokenIds,
  );

  /// Fetches trending tokens
  Future<Result<List<Map<String, dynamic>>>> getTrendingTokens();

  /// Fetches top performing tokens (24h)
  Future<Result<List<Map<String, dynamic>>>> getTopPerformers({
    int limit = 100,
  });

  /// Fetches market data for a specific token
  Future<Result<Map<String, dynamic>>> getTokenMarketData(String tokenId);

  /// Fetches global market data
  Future<Result<Map<String, dynamic>>> getGlobalMarketData();

  /// Fetches historical price data for a token
  Future<Result<List<Map<String, dynamic>>>> getHistoricalPrices(
    String tokenId, {
    int days = 7,
  });

  /// Fetches Algorand ecosystem tokens specifically
  Future<Result<List<Map<String, dynamic>>>> getAlgorandEcosystemTokens();

  /// Fetches token search results
  Future<Result<List<Map<String, dynamic>>>> searchTokens(String query);

  /// Fetches supported currencies
  Future<Result<List<String>>> getSupportedCurrencies();

  /// Formats price with appropriate decimal places
  String formatPrice(double price);

  /// Formats percentage change
  String formatPercentageChange(double change);

  /// Formats market cap
  String formatMarketCap(double marketCap);

  /// Formats volume
  String formatVolume(double volume);
}
