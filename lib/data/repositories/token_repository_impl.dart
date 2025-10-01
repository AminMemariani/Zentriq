import '../../domain/entities/token.dart';
import '../../domain/repositories/token_repository.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart' as failures;
import '../models/token_model.dart';

/// Implementation of TokenRepository
class TokenRepositoryImpl implements TokenRepository {
  const TokenRepositoryImpl();

  @override
  Future<Result<List<Token>>> getAllTokens() async {
    try {
      // TODO: Implement actual data source calls
      // For now, return mock tokens
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockTokens = _generateMockTokens();
      return Result.success(mockTokens);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Token>>> getTopPerformers({int limit = 10}) async {
    try {
      // TODO: Implement actual data source calls
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allTokens = _generateMockTokens();
      // Sort by price change percentage (descending) and take top performers
      allTokens.sort(
        (a, b) =>
            b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
      );
      final topPerformers = allTokens.take(limit).toList();

      return Result.success(topPerformers);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Token>> getTokenBySymbol(String symbol) async {
    try {
      // TODO: Implement actual data source calls
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allTokens = _generateMockTokens();
      final token = allTokens.firstWhere(
        (token) => token.symbol.toLowerCase() == symbol.toLowerCase(),
        orElse: () => throw Exception('Token not found'),
      );

      return Result.success(token);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Token>> getTokenById(String id) async {
    try {
      // TODO: Implement actual data source calls
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allTokens = _generateMockTokens();
      final token = allTokens.firstWhere(
        (token) => token.id == id,
        orElse: () => throw Exception('Token not found'),
      );

      return Result.success(token);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Token>>> refreshTokens() async {
    try {
      // TODO: Implement actual data source calls
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockTokens = _generateMockTokens();
      return Result.success(mockTokens);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Token>>> getTokensByMarketCap({int limit = 50}) async {
    try {
      // TODO: Implement actual data source calls
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allTokens = _generateMockTokens();
      // Sort by market cap (descending)
      allTokens.sort((a, b) => b.marketCap.compareTo(a.marketCap));
      final topByMarketCap = allTokens.take(limit).toList();

      return Result.success(topByMarketCap);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Token>>> getTokensByVolume({int limit = 50}) async {
    try {
      // TODO: Implement actual data source calls
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allTokens = _generateMockTokens();
      // Sort by volume (descending)
      allTokens.sort((a, b) => b.volume24h.compareTo(a.volume24h));
      final topByVolume = allTokens.take(limit).toList();

      return Result.success(topByVolume);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  /// Generates mock token data
  List<Token> _generateMockTokens() {
    final now = DateTime.now();
    return [
      TokenModel(
        id: 'algorand',
        symbol: 'ALGO',
        name: 'Algorand',
        price: 0.1523,
        priceChange24h: 0.0087,
        priceChangePercentage24h: 6.05,
        marketCap: 1200000000,
        volume24h: 45000000,
        rank: 1,
        circulatingSupply: 8000000000,
        totalSupply: 10000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'yieldly',
        symbol: 'YLDY',
        name: 'Yieldly',
        price: 0.0021,
        priceChange24h: 0.0003,
        priceChangePercentage24h: 16.67,
        marketCap: 21000000,
        volume24h: 1200000,
        rank: 2,
        circulatingSupply: 10000000000,
        totalSupply: 10000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'opulous',
        symbol: 'OPUL',
        name: 'Opulous',
        price: 0.0845,
        priceChange24h: -0.0023,
        priceChangePercentage24h: -2.65,
        marketCap: 84500000,
        volume24h: 2300000,
        rank: 3,
        circulatingSupply: 1000000000,
        totalSupply: 1000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'smile-coin',
        symbol: 'SMILE',
        name: 'Smile Coin',
        price: 0.0008,
        priceChange24h: 0.0001,
        priceChangePercentage24h: 14.29,
        marketCap: 8000000,
        volume24h: 450000,
        rank: 4,
        circulatingSupply: 10000000000,
        totalSupply: 10000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'planet-watch',
        symbol: 'PLANETS',
        name: 'Planet Watch',
        price: 0.0012,
        priceChange24h: -0.0001,
        priceChangePercentage24h: -7.69,
        marketCap: 12000000,
        volume24h: 320000,
        rank: 5,
        circulatingSupply: 10000000000,
        totalSupply: 10000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'akita-inu',
        symbol: 'AKITA',
        name: 'Akita Inu',
        price: 0.0000008,
        priceChange24h: 0.0000001,
        priceChangePercentage24h: 14.29,
        marketCap: 8000000,
        volume24h: 180000,
        rank: 6,
        circulatingSupply: 10000000000000,
        totalSupply: 10000000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'choice-coin',
        symbol: 'CHOICE',
        name: 'Choice Coin',
        price: 0.0003,
        priceChange24h: 0.00005,
        priceChangePercentage24h: 20.00,
        marketCap: 3000000,
        volume24h: 95000,
        rank: 7,
        circulatingSupply: 10000000000,
        totalSupply: 10000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'headline',
        symbol: 'HDL',
        name: 'Headline',
        price: 0.0045,
        priceChange24h: -0.0002,
        priceChangePercentage24h: -4.26,
        marketCap: 4500000,
        volume24h: 120000,
        rank: 8,
        circulatingSupply: 1000000000,
        totalSupply: 1000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'xfinite',
        symbol: 'XET',
        name: 'Xfinite Entertainment Token',
        price: 0.0006,
        priceChange24h: 0.0001,
        priceChangePercentage24h: 20.00,
        marketCap: 6000000,
        volume24h: 150000,
        rank: 9,
        circulatingSupply: 10000000000,
        totalSupply: 10000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'defly',
        symbol: 'DEFLY',
        name: 'Defly',
        price: 0.0018,
        priceChange24h: 0.0003,
        priceChangePercentage24h: 20.00,
        marketCap: 1800000,
        volume24h: 75000,
        rank: 10,
        circulatingSupply: 1000000000,
        totalSupply: 1000000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'usdc',
        symbol: 'USDC',
        name: 'USD Coin',
        price: 1.0000,
        priceChange24h: 0.0001,
        priceChangePercentage24h: 0.01,
        marketCap: 50000000,
        volume24h: 5000000,
        rank: 11,
        circulatingSupply: 50000000,
        totalSupply: 50000000,
        lastUpdated: now,
      ),
      TokenModel(
        id: 'usdt',
        symbol: 'USDT',
        name: 'Tether',
        price: 0.9999,
        priceChange24h: -0.0001,
        priceChangePercentage24h: -0.01,
        marketCap: 30000000,
        volume24h: 3000000,
        rank: 12,
        circulatingSupply: 30000000,
        totalSupply: 30000000,
        lastUpdated: now,
      ),
    ];
  }
}
