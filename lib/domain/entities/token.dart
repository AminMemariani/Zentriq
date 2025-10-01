import 'package:equatable/equatable.dart';

/// Token entity representing a cryptocurrency token
class Token extends Equatable {
  const Token({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.volume24h,
    this.logoUrl,
    this.rank,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.lastUpdated,
  });

  final String id;
  final String symbol;
  final String name;
  final double price;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final double volume24h;
  final String? logoUrl;
  final int? rank;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final DateTime? lastUpdated;

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    price,
    priceChange24h,
    priceChangePercentage24h,
    marketCap,
    volume24h,
    logoUrl,
    rank,
    circulatingSupply,
    totalSupply,
    maxSupply,
    lastUpdated,
  ];

  /// Returns formatted price with currency symbol
  String get formattedPrice => '\$${price.toStringAsFixed(4)}';

  /// Returns formatted price change with sign
  String get formattedPriceChange =>
      '${priceChange24h >= 0 ? '+' : ''}${priceChange24h.toStringAsFixed(4)}';

  /// Returns formatted price change percentage with sign
  String get formattedPriceChangePercentage =>
      '${priceChangePercentage24h >= 0 ? '+' : ''}${priceChangePercentage24h.toStringAsFixed(2)}%';

  /// Returns formatted market cap
  String get formattedMarketCap => _formatLargeNumber(marketCap);

  /// Returns formatted volume
  String get formattedVolume => _formatLargeNumber(volume24h);

  /// Returns formatted circulating supply
  String get formattedCirculatingSupply =>
      _formatLargeNumber(circulatingSupply ?? 0);

  /// Returns formatted total supply
  String get formattedTotalSupply => _formatLargeNumber(totalSupply ?? 0);

  /// Returns true if price change is positive
  bool get isPositiveChange => priceChangePercentage24h >= 0;

  /// Returns color for price change (green for positive, red for negative)
  String get changeColor => isPositiveChange ? 'positive' : 'negative';

  /// Returns formatted last updated time
  String get formattedLastUpdated {
    if (lastUpdated == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(lastUpdated!);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats large numbers with K, M, B suffixes
  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '\$${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '\$${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '\$${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '\$${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return '\$${number.toStringAsFixed(2)}';
    }
  }

  /// Creates a copy of this token with the given fields replaced with new values
  Token copyWith({
    String? id,
    String? symbol,
    String? name,
    double? price,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? marketCap,
    double? volume24h,
    String? logoUrl,
    int? rank,
    double? circulatingSupply,
    double? totalSupply,
    double? maxSupply,
    DateTime? lastUpdated,
  }) {
    return Token(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      logoUrl: logoUrl ?? this.logoUrl,
      rank: rank ?? this.rank,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      maxSupply: maxSupply ?? this.maxSupply,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
