import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/transaction_model.dart';
import 'package:zentriq/domain/entities/transaction.dart';

void main() {
  group('TransactionModel', () {
    final testTransaction = TransactionModel(
      id: '1',
      type: TransactionType.send,
      amount: 100.0,
      fromAddress: 'FROM123',
      toAddress: 'TO456',
      timestamp: DateTime.parse('2023-01-01T00:00:00.000Z'),
      note: 'Test transaction',
      fee: 0.001,
      status: TransactionStatus.completed,
    );

    const testJson = {
      'id': '1',
      'type': 'send',
      'amount': 100.0,
      'fromAddress': 'FROM123',
      'toAddress': 'TO456',
      'timestamp': '2023-01-01T00:00:00.000Z',
      'note': 'Test transaction',
      'fee': 0.001,
      'status': 'completed',
    };

    test('should create TransactionModel from JSON', () {
      // Act
      final result = TransactionModel.fromJson(testJson);

      // Assert
      expect(result.id, '1');
      expect(result.type, TransactionType.send);
      expect(result.amount, 100.0);
      expect(result.fromAddress, 'FROM123');
      expect(result.toAddress, 'TO456');
      expect(result.timestamp, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(result.note, 'Test transaction');
      expect(result.fee, 0.001);
      expect(result.status, TransactionStatus.completed);
    });

    test('should create TransactionModel from JSON with minimal data', () {
      // Arrange
      const minimalJson = {
        'id': '2',
        'type': 'receive',
        'amount': 50.0,
        'fromAddress': 'FROM789',
        'toAddress': 'TO012',
        'timestamp': '2023-01-01T12:00:00.000Z',
      };

      // Act
      final result = TransactionModel.fromJson(minimalJson);

      // Assert
      expect(result.id, '2');
      expect(result.type, TransactionType.receive);
      expect(result.amount, 50.0);
      expect(result.fromAddress, 'FROM789');
      expect(result.toAddress, 'TO012');
      expect(result.timestamp, DateTime.parse('2023-01-01T12:00:00.000Z'));
      expect(result.note, null);
      expect(result.fee, null);
      expect(result.status, TransactionStatus.completed);
    });

    test('should convert TransactionModel to JSON', () {
      // Act
      final result = testTransaction.toJson();

      // Assert
      expect(result['id'], '1');
      expect(result['type'], 'send');
      expect(result['amount'], 100.0);
      expect(result['fromAddress'], 'FROM123');
      expect(result['toAddress'], 'TO456');
      expect(result['timestamp'], '2023-01-01T00:00:00.000Z');
      expect(result['note'], 'Test transaction');
      expect(result['fee'], 0.001);
      expect(result['status'], 'completed');
    });

    test('should create TransactionModel from Transaction entity', () {
      // Arrange
      final entity = Transaction(
        id: '3',
        type: TransactionType.stake,
        amount: 200.0,
        fromAddress: 'FROM345',
        toAddress: 'TO678',
        timestamp: DateTime.parse('2023-01-01T18:00:00.000Z'),
        note: 'Entity transaction',
        fee: 0.002,
        status: TransactionStatus.pending,
      );

      // Act
      final result = TransactionModel.fromEntity(entity);

      // Assert
      expect(result.id, '3');
      expect(result.type, TransactionType.stake);
      expect(result.amount, 200.0);
      expect(result.fromAddress, 'FROM345');
      expect(result.toAddress, 'TO678');
      expect(result.timestamp, DateTime.parse('2023-01-01T18:00:00.000Z'));
      expect(result.note, 'Entity transaction');
      expect(result.fee, 0.002);
      expect(result.status, TransactionStatus.pending);
    });

    test('should handle unknown transaction type with default value', () {
      // Arrange
      const jsonWithUnknownType = {
        'id': '4',
        'type': 'unknown_type',
        'amount': 75.0,
        'fromAddress': 'FROM999',
        'toAddress': 'TO888',
        'timestamp': '2023-01-01T00:00:00.000Z',
      };

      // Act
      final result = TransactionModel.fromJson(jsonWithUnknownType);

      // Assert
      expect(result.type, TransactionType.send);
    });

    test('should handle unknown status with default value', () {
      // Arrange
      const jsonWithUnknownStatus = {
        'id': '5',
        'type': 'send',
        'amount': 25.0,
        'fromAddress': 'FROM777',
        'toAddress': 'TO666',
        'timestamp': '2023-01-01T00:00:00.000Z',
        'status': 'unknown_status',
      };

      // Act
      final result = TransactionModel.fromJson(jsonWithUnknownStatus);

      // Assert
      expect(result.status, TransactionStatus.completed);
    });

    test('should handle null optional fields in JSON', () {
      // Arrange
      const jsonWithNulls = {
        'id': '6',
        'type': 'send',
        'amount': 10.0,
        'fromAddress': 'FROM555',
        'toAddress': 'TO444',
        'timestamp': '2023-01-01T00:00:00.000Z',
        'note': null,
        'fee': null,
      };

      // Act
      final result = TransactionModel.fromJson(jsonWithNulls);

      // Assert
      expect(result.note, null);
      expect(result.fee, null);
      expect(result.status, TransactionStatus.completed);
    });

    test('should handle different transaction types', () {
      // Test send transaction
      const sendJson = {
        'id': '7',
        'type': 'send',
        'amount': 100.0,
        'fromAddress': 'FROM111',
        'toAddress': 'TO222',
        'timestamp': '2023-01-01T00:00:00.000Z',
      };
      final sendResult = TransactionModel.fromJson(sendJson);
      expect(sendResult.type, TransactionType.send);

      // Test receive transaction
      const receiveJson = {
        'id': '8',
        'type': 'receive',
        'amount': 200.0,
        'fromAddress': 'FROM333',
        'toAddress': 'TO444',
        'timestamp': '2023-01-01T00:00:00.000Z',
      };
      final receiveResult = TransactionModel.fromJson(receiveJson);
      expect(receiveResult.type, TransactionType.receive);

      // Test stake transaction
      const stakeJson = {
        'id': '9',
        'type': 'stake',
        'amount': 300.0,
        'fromAddress': 'FROM555',
        'toAddress': 'TO666',
        'timestamp': '2023-01-01T00:00:00.000Z',
      };
      final stakeResult = TransactionModel.fromJson(stakeJson);
      expect(stakeResult.type, TransactionType.stake);
    });
  });
}
