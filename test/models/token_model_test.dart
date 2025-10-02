import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/token_model.dart';
import 'package:zentriq/domain/entities/token.dart';

void main() {
  group('TokenModel', () {
    const testToken = Token(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 50000.0,
      priceChange24h: 1000.0,
      priceChangePercentage24h: 2.0,
      marketCap: 1000000000000.0,
      volume24h: 50000000000.0,
      logoUrl: 'https://example.com/btc.png',
      rank: 1,
      circulatingSupply: 19000000.0,
      totalSupply: 21000000.0,
      maxSupply: 21000000.0,
      lastUpdated: null,
    );

    test('should create TokenModel from JSON', () {
      // Arrange
      final json = {
        'id': 'bitcoin',
        'symbol': 'BTC',
        'name': 'Bitcoin',
        'price': 50000.0,
        'price_change_24h': 1000.0,
        'price_change_percentage_24h': 2.0,
        'market_cap': 1000000000000.0,
        'volume_24h': 50000000000.0,
        'logo_url': 'https://example.com/btc.png',
        'rank': 1,
        'circulating_supply': 19000000.0,
        'total_supply': 21000000.0,
        'max_supply': 21000000.0,
        'last_updated': '2023-01-01T00:00:00.000Z',
      };

      // Act
      final tokenModel = TokenModel.fromJson(json);

      // Assert
      expect(tokenModel.id, 'bitcoin');
      expect(tokenModel.symbol, 'BTC');
      expect(tokenModel.name, 'Bitcoin');
      expect(tokenModel.price, 50000.0);
      expect(tokenModel.priceChange24h, 1000.0);
      expect(tokenModel.priceChangePercentage24h, 2.0);
      expect(tokenModel.marketCap, 1000000000000.0);
      expect(tokenModel.volume24h, 50000000000.0);
      expect(tokenModel.logoUrl, 'https://example.com/btc.png');
      expect(tokenModel.rank, 1);
      expect(tokenModel.circulatingSupply, 19000000.0);
      expect(tokenModel.totalSupply, 21000000.0);
      expect(tokenModel.maxSupply, 21000000.0);
      expect(
          tokenModel.lastUpdated, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('should create TokenModel from JSON with null optional fields', () {
      // Arrange
      final json = {
        'id': 'bitcoin',
        'symbol': 'BTC',
        'name': 'Bitcoin',
        'price': 50000.0,
        'price_change_24h': 1000.0,
        'price_change_percentage_24h': 2.0,
        'market_cap': 1000000000000.0,
        'volume_24h': 50000000000.0,
        'logo_url': null,
        'rank': null,
        'circulating_supply': null,
        'total_supply': null,
        'max_supply': null,
        'last_updated': null,
      };

      // Act
      final tokenModel = TokenModel.fromJson(json);

      // Assert
      expect(tokenModel.id, 'bitcoin');
      expect(tokenModel.symbol, 'BTC');
      expect(tokenModel.name, 'Bitcoin');
      expect(tokenModel.price, 50000.0);
      expect(tokenModel.logoUrl, null);
      expect(tokenModel.rank, null);
      expect(tokenModel.circulatingSupply, null);
      expect(tokenModel.totalSupply, null);
      expect(tokenModel.maxSupply, null);
      expect(tokenModel.lastUpdated, null);
    });

    test('should convert TokenModel to JSON', () {
      // Arrange
      final tokenModel = TokenModel(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 50000.0,
        priceChange24h: 1000.0,
        priceChangePercentage24h: 2.0,
        marketCap: 1000000000000.0,
        volume24h: 50000000000.0,
        logoUrl: 'https://example.com/btc.png',
        rank: 1,
        circulatingSupply: 19000000.0,
        totalSupply: 21000000.0,
        maxSupply: 21000000.0,
        lastUpdated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      // Act
      final json = tokenModel.toJson();

      // Assert
      expect(json['id'], 'bitcoin');
      expect(json['symbol'], 'BTC');
      expect(json['name'], 'Bitcoin');
      expect(json['price'], 50000.0);
      expect(json['price_change_24h'], 1000.0);
      expect(json['price_change_percentage_24h'], 2.0);
      expect(json['market_cap'], 1000000000000.0);
      expect(json['volume_24h'], 50000000000.0);
      expect(json['logo_url'], 'https://example.com/btc.png');
      expect(json['rank'], 1);
      expect(json['circulating_supply'], 19000000.0);
      expect(json['total_supply'], 21000000.0);
      expect(json['max_supply'], 21000000.0);
      expect(json['last_updated'], '2023-01-01T00:00:00.000Z');
    });

    test('should create TokenModel from Token entity', () {
      // Act
      final tokenModel = TokenModel.fromEntity(testToken);

      // Assert
      expect(tokenModel.id, testToken.id);
      expect(tokenModel.symbol, testToken.symbol);
      expect(tokenModel.name, testToken.name);
      expect(tokenModel.price, testToken.price);
      expect(tokenModel.priceChange24h, testToken.priceChange24h);
      expect(tokenModel.priceChangePercentage24h,
          testToken.priceChangePercentage24h);
      expect(tokenModel.marketCap, testToken.marketCap);
      expect(tokenModel.volume24h, testToken.volume24h);
      expect(tokenModel.logoUrl, testToken.logoUrl);
      expect(tokenModel.rank, testToken.rank);
      expect(tokenModel.circulatingSupply, testToken.circulatingSupply);
      expect(tokenModel.totalSupply, testToken.totalSupply);
      expect(tokenModel.maxSupply, testToken.maxSupply);
      expect(tokenModel.lastUpdated, testToken.lastUpdated);
    });

    test('should handle null optional fields in toJson', () {
      // Arrange
      final tokenModel = TokenModel(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 50000.0,
        priceChange24h: 1000.0,
        priceChangePercentage24h: 2.0,
        marketCap: 1000000000000.0,
        volume24h: 50000000000.0,
        logoUrl: null,
        rank: null,
        circulatingSupply: null,
        totalSupply: null,
        maxSupply: null,
        lastUpdated: null,
      );

      // Act
      final json = tokenModel.toJson();

      // Assert
      expect(json['logo_url'], null);
      expect(json['rank'], null);
      expect(json['circulating_supply'], null);
      expect(json['total_supply'], null);
      expect(json['max_supply'], null);
      expect(json['last_updated'], null);
    });
  });
}
