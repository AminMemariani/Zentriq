import 'package:flutter/foundation.dart';
import '../domain/entities/token.dart';
import '../domain/usecases/get_all_tokens.dart';
import '../domain/usecases/get_top_performers.dart';
import '../core/viewmodels/base_viewmodel.dart';
import '../core/utils/result.dart';
import '../core/errors/failures.dart' as failures;

/// Refactored ViewModel for token-related operations with improved scalability
class RefactoredTokenViewModel extends BaseViewModel {
  RefactoredTokenViewModel(this._getAllTokens, this._getTopPerformers);

  final GetAllTokens _getAllTokens;
  final GetTopPerformers _getTopPerformers;

  // Token state
  List<Token> _allTokens = [];
  List<Token> _topPerformers = [];
  bool _isLoadingAllTokens = false;
  bool _isLoadingTopPerformers = false;
  String? _allTokensErrorMessage;
  String? _topPerformersErrorMessage;

  // Getters
  List<Token> get allTokens => List.unmodifiable(_allTokens);
  List<Token> get topPerformers => List.unmodifiable(_topPerformers);

  bool get isLoadingAllTokens => _isLoadingAllTokens;
  bool get isLoadingTopPerformers => _isLoadingTopPerformers;

  String? get allTokensErrorMessage => _allTokensErrorMessage;
  String? get topPerformersErrorMessage => _topPerformersErrorMessage;

  bool get hasAllTokensError => _allTokensErrorMessage != null;
  bool get hasTopPerformersError => _topPerformersErrorMessage != null;

  /// Loads all tokens
  Future<void> loadAllTokens() async {
    await executeResultOperation(
      () => _getAllTokens(),
      onSuccess: (tokens) {
        _allTokens = tokens;
        _allTokensErrorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Loads top performing tokens
  Future<void> loadTopPerformers({int limit = 10}) async {
    await executeResultOperation(
      () => _getTopPerformers(GetTopPerformersParams(limit: limit)),
      onSuccess: (tokens) {
        _topPerformers = tokens;
        _topPerformersErrorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Refreshes all token data
  Future<void> refreshTokens() async {
    await Future.wait([loadAllTokens(), loadTopPerformers()]);
  }

  /// Gets tokens sorted by price change percentage
  List<Token> getTokensByPriceChange({int limit = 50}) {
    final sortedTokens = List<Token>.from(_allTokens);
    sortedTokens.sort(
      (a, b) =>
          b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
    );
    return sortedTokens.take(limit).toList();
  }

  /// Gets tokens sorted by market cap
  List<Token> getTokensByMarketCap({int limit = 50}) {
    final sortedTokens = List<Token>.from(_allTokens);
    sortedTokens.sort((a, b) => b.marketCap.compareTo(a.marketCap));
    return sortedTokens.take(limit).toList();
  }

  /// Gets tokens sorted by volume
  List<Token> getTokensByVolume({int limit = 50}) {
    final sortedTokens = List<Token>.from(_allTokens);
    sortedTokens.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    return sortedTokens.take(limit).toList();
  }

  /// Searches tokens by name or symbol
  List<Token> searchTokens(String query) {
    if (query.isEmpty) return _allTokens;

    final lowercaseQuery = query.toLowerCase();
    return _allTokens.where((token) {
      return token.name.toLowerCase().contains(lowercaseQuery) ||
          token.symbol.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Gets a token by its ID
  Token? getTokenById(String id) {
    try {
      return _allTokens.firstWhere((token) => token.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets tokens by price range
  List<Token> getTokensByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) {
    return _allTokens.where((token) {
      return token.price >= minPrice && token.price <= maxPrice;
    }).toList();
  }

  /// Gets tokens with positive price change
  List<Token> getGainers({int limit = 20}) {
    final gainers = _allTokens
        .where((token) => token.priceChangePercentage24h > 0)
        .toList();
    gainers.sort(
      (a, b) =>
          b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
    );
    return gainers.take(limit).toList();
  }

  /// Gets tokens with negative price change
  List<Token> getLosers({int limit = 20}) {
    final losers = _allTokens
        .where((token) => token.priceChangePercentage24h < 0)
        .toList();
    losers.sort(
      (a, b) =>
          a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h),
    );
    return losers.take(limit).toList();
  }

  /// Gets tokens with highest market cap
  List<Token> getTopByMarketCap({int limit = 20}) {
    final sortedTokens = List<Token>.from(_allTokens);
    sortedTokens.sort((a, b) => b.marketCap.compareTo(a.marketCap));
    return sortedTokens.take(limit).toList();
  }

  /// Gets tokens with highest volume
  List<Token> getTopByVolume({int limit = 20}) {
    final sortedTokens = List<Token>.from(_allTokens);
    sortedTokens.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    return sortedTokens.take(limit).toList();
  }

  /// Calculates portfolio value (mock implementation)
  double getPortfolioValue() {
    // This would typically calculate based on user's token holdings
    // For now, return a mock value
    return _allTokens.fold(0.0, (sum, token) => sum + token.price * 100);
  }

  /// Calculates portfolio change percentage (mock implementation)
  double getPortfolioChangePercentage() {
    // This would typically calculate based on user's token holdings
    // For now, return a mock value
    if (_allTokens.isEmpty) return 0.0;

    final totalChange = _allTokens.fold(
      0.0,
      (sum, token) => sum + token.priceChangePercentage24h,
    );
    return totalChange / _allTokens.length;
  }

  /// Gets token statistics
  TokenStatistics getTokenStatistics() {
    if (_allTokens.isEmpty) {
      return TokenStatistics.empty();
    }

    final totalTokens = _allTokens.length;
    final gainers = _allTokens
        .where((t) => t.priceChangePercentage24h > 0)
        .length;
    final losers = _allTokens
        .where((t) => t.priceChangePercentage24h < 0)
        .length;
    final totalMarketCap = _allTokens.fold(0.0, (sum, t) => sum + t.marketCap);
    final totalVolume = _allTokens.fold(0.0, (sum, t) => sum + t.volume24h);

    return TokenStatistics(
      totalTokens: totalTokens,
      gainers: gainers,
      losers: losers,
      totalMarketCap: totalMarketCap,
      totalVolume: totalVolume,
    );
  }

  /// Clears all error states
  void clearAllErrors() {
    _allTokensErrorMessage = null;
    _topPerformersErrorMessage = null;
    notifyListeners();
  }

  /// Resets all state
  void reset() {
    _allTokens.clear();
    _topPerformers.clear();
    _allTokensErrorMessage = null;
    _topPerformersErrorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Parameters for getting top performers
class GetTopPerformersParams {
  final int limit;

  const GetTopPerformersParams({required this.limit});
}

/// Token statistics data class
class TokenStatistics {
  final int totalTokens;
  final int gainers;
  final int losers;
  final double totalMarketCap;
  final double totalVolume;

  const TokenStatistics({
    required this.totalTokens,
    required this.gainers,
    required this.losers,
    required this.totalMarketCap,
    required this.totalVolume,
  });

  factory TokenStatistics.empty() {
    return const TokenStatistics(
      totalTokens: 0,
      gainers: 0,
      losers: 0,
      totalMarketCap: 0.0,
      totalVolume: 0.0,
    );
  }

  double get gainersPercentage =>
      totalTokens > 0 ? (gainers / totalTokens) * 100 : 0.0;
  double get losersPercentage =>
      totalTokens > 0 ? (losers / totalTokens) * 100 : 0.0;
}
