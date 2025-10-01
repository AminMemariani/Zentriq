import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart' as failures;
import 'interfaces/token_pricing_service_interface.dart';

/// Token pricing service for fetching market data from various APIs
class TokenPricingService implements TokenPricingServiceInterface {
  TokenPricingService({this.coinGeckoApiKey, this.coinMarketCapApiKey});

  final String? coinGeckoApiKey;
  final String? coinMarketCapApiKey;

  // Base URLs for different price APIs
  static const String _coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String _cryptoCompareBaseUrl =
      'https://min-api.cryptocompare.com/data';

  /// Headers for CoinGecko API
  Map<String, String> get _coinGeckoHeaders => {
    'Content-Type': 'application/json',
    if (coinGeckoApiKey != null) 'x-cg-pro-api-key': coinGeckoApiKey!,
  };

  /// Fetches token price data from CoinGecko
  @override
  Future<Result<Map<String, dynamic>>> getTokenPrice(String tokenId) async {
    try {
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/simple/price?ids=$tokenId&vs_currencies=usd&include_24hr_change=true&include_market_cap=true&include_24hr_vol=true',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch token price from CoinGecko: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches multiple token prices from CoinGecko
  @override
  Future<Result<Map<String, dynamic>>> getMultipleTokenPrices(
    List<String> tokenIds,
  ) async {
    try {
      final ids = tokenIds.join(',');
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/simple/price?ids=$ids&vs_currencies=usd&include_24hr_change=true&include_market_cap=true&include_24hr_vol=true',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch multiple token prices: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches trending tokens from CoinGecko
  @override
  Future<Result<List<Map<String, dynamic>>>> getTrendingTokens() async {
    try {
      final url = Uri.parse('$_coinGeckoBaseUrl/search/trending');
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final coins =
            (data['coins'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            [];
        return Result.success(coins);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch trending tokens: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches top performing tokens (24h)
  @override
  Future<Result<List<Map<String, dynamic>>>> getTopPerformers({
    int limit = 100,
  }) async {
    try {
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/coins/markets?vs_currency=usd&order=price_change_percentage_24h_desc&per_page=$limit&page=1&sparkline=false&price_change_percentage=24h',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final tokens = data.cast<Map<String, dynamic>>();
        return Result.success(tokens);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch top performers: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches market data for a specific token
  @override
  Future<Result<Map<String, dynamic>>> getTokenMarketData(
    String tokenId,
  ) async {
    try {
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/coins/$tokenId?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch token market data: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches global market data
  @override
  Future<Result<Map<String, dynamic>>> getGlobalMarketData() async {
    try {
      final url = Uri.parse('$_coinGeckoBaseUrl/global');
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch global market data: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches historical price data for a token
  @override
  Future<Result<List<Map<String, dynamic>>>> getHistoricalPrices(
    String tokenId, {
    int days = 7,
  }) async {
    try {
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/coins/$tokenId/market_chart?vs_currency=usd&days=$days&interval=daily',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final prices =
            (data['prices'] as List<dynamic>?)?.cast<List<dynamic>>() ?? [];

        final historicalData = prices
            .map((price) => {'timestamp': price[0], 'price': price[1]})
            .cast<Map<String, dynamic>>()
            .toList();

        return Result.success(historicalData);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch historical prices: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches token data from CryptoCompare
  Future<Result<Map<String, dynamic>>> getTokenDataFromCryptoCompare(
    String symbol,
  ) async {
    try {
      final url = Uri.parse(
        '$_cryptoCompareBaseUrl/pricemultifull?fsyms=$symbol&tsyms=USD',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch token data from CryptoCompare: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches Algorand ecosystem tokens specifically
  @override
  Future<Result<List<Map<String, dynamic>>>>
  getAlgorandEcosystemTokens() async {
    try {
      // CoinGecko platform ID for Algorand
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/coins/markets?vs_currency=usd&category=algorand-ecosystem&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final tokens = data.cast<Map<String, dynamic>>();
        return Result.success(tokens);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch Algorand ecosystem tokens: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches token search results
  @override
  Future<Result<List<Map<String, dynamic>>>> searchTokens(String query) async {
    try {
      final url = Uri.parse('$_coinGeckoBaseUrl/search?query=$query');
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final coins =
            (data['coins'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            [];
        return Result.success(coins);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to search tokens: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches supported currencies
  @override
  Future<Result<List<String>>> getSupportedCurrencies() async {
    try {
      final url = Uri.parse(
        '$_coinGeckoBaseUrl/simple/supported_vs_currencies',
      );
      final response = await http.get(url, headers: _coinGeckoHeaders);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final currencies = data.cast<String>();
        return Result.success(currencies);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch supported currencies: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Formats price with appropriate decimal places
  @override
  String formatPrice(double price) {
    if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsFixed(8)}';
    }
  }

  /// Formats percentage change
  @override
  String formatPercentageChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  /// Formats market cap
  @override
  String formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(2)}M';
    } else if (marketCap >= 1e3) {
      return '\$${(marketCap / 1e3).toStringAsFixed(2)}K';
    } else {
      return '\$${marketCap.toStringAsFixed(2)}';
    }
  }

  /// Formats volume
  @override
  String formatVolume(double volume) {
    if (volume >= 1e9) {
      return '\$${(volume / 1e9).toStringAsFixed(2)}B';
    } else if (volume >= 1e6) {
      return '\$${(volume / 1e6).toStringAsFixed(2)}M';
    } else if (volume >= 1e3) {
      return '\$${(volume / 1e3).toStringAsFixed(2)}K';
    } else {
      return '\$${volume.toStringAsFixed(2)}';
    }
  }
}
