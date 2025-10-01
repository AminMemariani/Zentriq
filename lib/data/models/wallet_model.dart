import '../../domain/entities/wallet.dart';

/// Wallet model for data layer
class WalletModel extends Wallet {
  const WalletModel({
    required super.address,
    required super.balance,
    required super.balanceInUSD,
    super.name,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a WalletModel from a JSON map
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      address: json['address'] as String,
      balance: (json['balance'] as num).toDouble(),
      balanceInUSD: (json['balanceInUSD'] as num).toDouble(),
      name: json['name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Converts this WalletModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'balance': balance,
      'balanceInUSD': balanceInUSD,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a WalletModel from a Wallet entity
  factory WalletModel.fromEntity(Wallet wallet) {
    return WalletModel(
      address: wallet.address,
      balance: wallet.balance,
      balanceInUSD: wallet.balanceInUSD,
      name: wallet.name,
      createdAt: wallet.createdAt,
      updatedAt: wallet.updatedAt,
    );
  }
}
