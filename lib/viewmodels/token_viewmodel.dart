import 'package:flutter/foundation.dart';
import '../domain/entities/token.dart';
import '../domain/usecases/get_all_tokens.dart';
import '../domain/usecases/get_top_performers.dart';
import '../core/errors/failures.dart' as failures;

/// ViewModel for token-related operations using Provider
class TokenViewModel extends ChangeNotifier {
  TokenViewModel(this._getAllTokens, this._getTopPerformers);

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
  List<Token> get allTokens => _allTokens;
  List<Token> get topPerformers => _topPerformers;
  bool get isLoadingAllTokens => _isLoadingAllTokens;
  bool get isLoadingTopPerformers => _isLoadingTopPerformers;
  String? get allTokensErrorMessage => _allTokensErrorMessage;
  String? get topPerformersErrorMessage => _topPerformersErrorMessage;
  bool get hasAllTokensError => _allTokensErrorMessage != null;
  bool get hasTopPerformersError => _topPerformersErrorMessage != null;

  /// Loads all tokens
  Future<void> loadAllTokens() async {
    _setAllTokensLoading(true);
    _clearAllTokensError();

    final result = await _getAllTokens();

    result
        .onSuccess((tokens) {
          _allTokens = tokens;
          notifyListeners();
        })
        .onFailure((failure) {
          _setAllTokensError(_getErrorMessage(failure));
        });

    _setAllTokensLoading(false);
  }

  /// Loads top performing tokens
  Future<void> loadTopPerformers({int limit = 10}) async {
    _setTopPerformersLoading(true);
    _clearTopPerformersError();

    final params = GetTopPerformersParams(limit: limit);
    final result = await _getTopPerformers(params);

    result
        .onSuccess((tokens) {
          _topPerformers = tokens;
          notifyListeners();
        })
        .onFailure((failure) {
          _setTopPerformersError(_getErrorMessage(failure));
        });

    _setTopPerformersLoading(false);
  }

  /// Refreshes all token data
  Future<void> refreshTokens() async {
    await Future.wait([loadAllTokens(), loadTopPerformers()]);
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

  /// Gets tokens sorted by price change percentage
  List<Token> getTokensByPriceChange({int limit = 50}) {
    final sortedTokens = List<Token>.from(_allTokens);
    sortedTokens.sort(
      (a, b) =>
          b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h),
    );
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

  /// Gets token by symbol
  Token? getTokenBySymbol(String symbol) {
    try {
      return _allTokens.firstWhere(
        (token) => token.symbol.toLowerCase() == symbol.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Gets token by ID
  Token? getTokenById(String id) {
    try {
      return _allTokens.firstWhere((token) => token.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets portfolio value (mock calculation)
  double getPortfolioValue() {
    // Mock portfolio calculation
    double totalValue = 0.0;
    for (final token in _allTokens.take(5)) {
      // Mock holding amounts
      final holdingAmount = _getMockHoldingAmount(token.symbol);
      totalValue += token.price * holdingAmount;
    }
    return totalValue;
  }

  /// Gets portfolio change percentage (mock calculation)
  double getPortfolioChangePercentage() {
    // Mock portfolio change calculation
    double totalChange = 0.0;
    int count = 0;
    for (final token in _allTokens.take(5)) {
      totalChange += token.priceChangePercentage24h;
      count++;
    }
    return count > 0 ? totalChange / count : 0.0;
  }

  // Private methods for state management
  void _setAllTokensLoading(bool loading) {
    _isLoadingAllTokens = loading;
    notifyListeners();
  }

  void _setAllTokensError(String message) {
    _allTokensErrorMessage = message;
    notifyListeners();
  }

  void _clearAllTokensError() {
    _allTokensErrorMessage = null;
  }

  void _setTopPerformersLoading(bool loading) {
    _isLoadingTopPerformers = loading;
    notifyListeners();
  }

  void _setTopPerformersError(String message) {
    _topPerformersErrorMessage = message;
    notifyListeners();
  }

  void _clearTopPerformersError() {
    _topPerformersErrorMessage = null;
  }

  /// Converts a failure to a user-friendly error message
  String _getErrorMessage(failures.Failure failure) {
    switch (failure.runtimeType) {
      case failures.NetworkFailure _:
        return 'No internet connection. Please check your network.';
      case failures.ServerFailure _:
        return 'Server error. Please try again later.';
      case failures.CacheFailure _:
        return 'Failed to load data from cache.';
      case failures.ValidationFailure _:
        return 'Invalid data. Please check your input.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Mock holding amounts for portfolio calculation
  double _getMockHoldingAmount(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'ALGO':
        return 1000.0;
      case 'YLDY':
        return 50000.0;
      case 'OPUL':
        return 1000.0;
      case 'SMILE':
        return 100000.0;
      case 'PLANETS':
        return 50000.0;
      default:
        return 100.0;
    }
  }
}
