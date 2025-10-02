import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/wallet_model.dart';
import 'package:zentriq/domain/entities/wallet.dart';

void main() {
  group('WalletModel', () {
    const testWallet = Wallet(
      address: '0x1234567890abcdef',
      balance: 1000.0,
      balanceInUSD: 50000.0,
      name: 'My Wallet',
      createdAt: null,
      updatedAt: null,
    );

    test('should create WalletModel from JSON', () {
      // Arrange
      final json = {
        'address': '0x1234567890abcdef',
        'balance': 1000.0,
        'balanceInUSD': 50000.0,
        'name': 'My Wallet',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
      };

      // Act
      final walletModel = WalletModel.fromJson(json);

      // Assert
      expect(walletModel.address, '0x1234567890abcdef');
      expect(walletModel.balance, 1000.0);
      expect(walletModel.balanceInUSD, 50000.0);
      expect(walletModel.name, 'My Wallet');
      expect(walletModel.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(walletModel.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('should create WalletModel from JSON with null optional fields', () {
      // Arrange
      final json = {
        'address': '0x1234567890abcdef',
        'balance': 1000.0,
        'balanceInUSD': 50000.0,
        'name': null,
        'created_at': null,
        'updated_at': null,
      };

      // Act
      final walletModel = WalletModel.fromJson(json);

      // Assert
      expect(walletModel.address, '0x1234567890abcdef');
      expect(walletModel.balance, 1000.0);
      expect(walletModel.balanceInUSD, 50000.0);
      expect(walletModel.name, null);
      expect(walletModel.createdAt, null);
      expect(walletModel.updatedAt, null);
    });

    test('should convert WalletModel to JSON', () {
      // Arrange
      final walletModel = WalletModel(
        address: '0x1234567890abcdef',
        balance: 1000.0,
        balanceInUSD: 50000.0,
        name: 'My Wallet',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      // Act
      final json = walletModel.toJson();

      // Assert
      expect(json['address'], '0x1234567890abcdef');
      expect(json['balance'], 1000.0);
      expect(json['balanceInUSD'], 50000.0);
      expect(json['name'], 'My Wallet');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });

    test('should create WalletModel from Wallet entity', () {
      // Act
      final walletModel = WalletModel.fromEntity(testWallet);

      // Assert
      expect(walletModel.address, testWallet.address);
      expect(walletModel.balance, testWallet.balance);
      expect(walletModel.balanceInUSD, testWallet.balanceInUSD);
      expect(walletModel.name, testWallet.name);
      expect(walletModel.createdAt, testWallet.createdAt);
      expect(walletModel.updatedAt, testWallet.updatedAt);
    });

    test('should handle null optional fields in toJson', () {
      // Arrange
      final walletModel = WalletModel(
        address: '0x1234567890abcdef',
        balance: 1000.0,
        balanceInUSD: 50000.0,
        name: null,
        createdAt: null,
        updatedAt: null,
      );

      // Act
      final json = walletModel.toJson();

      // Assert
      expect(json['name'], null);
      expect(json['created_at'], null);
      expect(json['updated_at'], null);
    });

    test('should handle zero balance', () {
      // Arrange
      final json = {
        'address': '0x1234567890abcdef',
        'balance': 0.0,
        'balanceInUSD': 0.0,
        'name': 'Empty Wallet',
        'created_at': null,
        'updated_at': null,
      };

      // Act
      final walletModel = WalletModel.fromJson(json);

      // Assert
      expect(walletModel.balance, 0.0);
      expect(walletModel.balanceInUSD, 0.0);
    });
  });
}
