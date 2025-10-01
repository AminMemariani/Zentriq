import '../../domain/entities/token.dart';

/// Token model for data layer
class TokenModel extends Token {
  const TokenModel({
    required super.id,
    required super.symbol,
    required super.name,
    required super.price,
    required super.priceChange24h,
    required super.priceChangePercentage24h,
    required super.marketCap,
    required super.volume24h,
    super.logoUrl,
    super.rank,
    super.circulatingSupply,
    super.totalSupply,
    super.maxSupply,
    super.lastUpdated,
  });

  /// Creates a TokenModel from a JSON map
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      priceChange24h: (json['price_change_24h'] as num).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num)
          .toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      volume24h: (json['volume_24h'] as num).toDouble(),
      logoUrl: json['logo_url'] as String?,
      rank: json['rank'] as int?,
      circulatingSupply: json['circulating_supply'] != null
          ? (json['circulating_supply'] as num).toDouble()
          : null,
      totalSupply: json['total_supply'] != null
          ? (json['total_supply'] as num).toDouble()
          : null,
      maxSupply: json['max_supply'] != null
          ? (json['max_supply'] as num).toDouble()
          : null,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  /// Converts this TokenModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'price': price,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap': marketCap,
      'volume_24h': volume24h,
      'logo_url': logoUrl,
      'rank': rank,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Creates a TokenModel from a Token entity
  factory TokenModel.fromEntity(Token token) {
    return TokenModel(
      id: token.id,
      symbol: token.symbol,
      name: token.name,
      price: token.price,
      priceChange24h: token.priceChange24h,
      priceChangePercentage24h: token.priceChangePercentage24h,
      marketCap: token.marketCap,
      volume24h: token.volume24h,
      logoUrl: token.logoUrl,
      rank: token.rank,
      circulatingSupply: token.circulatingSupply,
      totalSupply: token.totalSupply,
      maxSupply: token.maxSupply,
      lastUpdated: token.lastUpdated,
    );
  }
}
