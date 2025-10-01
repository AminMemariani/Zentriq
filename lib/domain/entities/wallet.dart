import 'package:equatable/equatable.dart';

/// Wallet entity representing a user's wallet
class Wallet extends Equatable {
  const Wallet({
    required this.address,
    required this.balance,
    required this.balanceInUSD,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  final String address;
  final double balance; // Balance in ALGO
  final double balanceInUSD; // Balance in USD
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    address,
    balance,
    balanceInUSD,
    name,
    createdAt,
    updatedAt,
  ];

  /// Creates a copy of this wallet with the given fields replaced with new values
  Wallet copyWith({
    String? address,
    double? balance,
    double? balanceInUSD,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      balanceInUSD: balanceInUSD ?? this.balanceInUSD,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Returns a formatted address (first 6 and last 4 characters)
  String get formattedAddress {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  /// Returns formatted balance with ALGO symbol
  String get formattedBalance => '${balance.toStringAsFixed(2)} ALGO';

  /// Returns formatted USD balance
  String get formattedBalanceUSD => '\$${balanceInUSD.toStringAsFixed(2)} USD';
}
