import '../../domain/entities/transaction.dart';

/// Transaction model for data layer
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.fromAddress,
    required super.toAddress,
    required super.timestamp,
    super.note,
    super.fee,
    super.status,
  });

  /// Creates a TransactionModel from a JSON map
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.send,
      ),
      amount: (json['amount'] as num).toDouble(),
      fromAddress: json['fromAddress'] as String,
      toAddress: json['toAddress'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
      fee: json['fee'] != null ? (json['fee'] as num).toDouble() : null,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
    );
  }

  /// Converts this TransactionModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'fee': fee,
      'status': status.name,
    };
  }

  /// Creates a TransactionModel from a Transaction entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount,
      fromAddress: transaction.fromAddress,
      toAddress: transaction.toAddress,
      timestamp: transaction.timestamp,
      note: transaction.note,
      fee: transaction.fee,
      status: transaction.status,
    );
  }
}
