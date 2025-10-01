import 'package:equatable/equatable.dart';

/// Transaction entity representing a wallet transaction
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fromAddress,
    required this.toAddress,
    required this.timestamp,
    this.note,
    this.fee,
    this.status = TransactionStatus.completed,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final String fromAddress;
  final String toAddress;
  final DateTime timestamp;
  final String? note;
  final double? fee;
  final TransactionStatus status;

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    fromAddress,
    toAddress,
    timestamp,
    note,
    fee,
    status,
  ];

  /// Returns formatted amount with ALGO symbol
  String get formattedAmount => '${amount.toStringAsFixed(2)} ALGO';

  /// Returns formatted timestamp
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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

  /// Returns formatted address (first 6 and last 4 characters)
  String formatAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  /// Returns the counterparty address for display
  String get counterpartyAddress {
    return type == TransactionType.send ? toAddress : fromAddress;
  }

  /// Returns formatted counterparty address
  String get formattedCounterpartyAddress => formatAddress(counterpartyAddress);
}

/// Transaction type enum
enum TransactionType { send, receive, stake, unstake }

/// Transaction status enum
enum TransactionStatus { pending, completed, failed }
