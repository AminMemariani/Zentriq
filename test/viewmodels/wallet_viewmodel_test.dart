import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zentriq/core/errors/failures.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/domain/entities/transaction.dart';
import 'package:zentriq/domain/entities/wallet.dart';
import 'package:zentriq/domain/usecases/get_transaction_history.dart';
import 'package:zentriq/domain/usecases/get_wallet.dart';
import 'package:zentriq/domain/usecases/send_transaction.dart';
import 'package:zentriq/viewmodels/wallet_viewmodel.dart';

import '../mocks/mock_repositories.mocks.dart';

void main() {
  group('WalletViewModel', () {
    late WalletViewModel viewModel;
    late MockGetWallet mockGetWallet;
    late MockGetTransactionHistory mockGetTransactionHistory;
    late MockSendTransaction mockSendTransaction;

    setUp(() {
      mockGetWallet = MockGetWallet();
      mockGetTransactionHistory = MockGetTransactionHistory();
      mockSendTransaction = MockSendTransaction();
      viewModel = WalletViewModel(
        mockGetWallet,
        mockGetTransactionHistory,
        mockSendTransaction,
      );
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(viewModel.wallet, isNull);
        expect(viewModel.transactions, isEmpty);
        expect(viewModel.isLoadingWallet, isFalse);
        expect(viewModel.isLoadingTransactions, isFalse);
        expect(viewModel.hasWalletError, isFalse);
        expect(viewModel.hasTransactionsError, isFalse);
        expect(viewModel.walletErrorMessage, isNull);
        expect(viewModel.transactionsErrorMessage, isNull);
        expect(viewModel.isSendingTransaction, isFalse);
        expect(viewModel.hasSendError, isFalse);
        expect(viewModel.sendErrorMessage, isNull);
      });
    });

    group('Load Wallet', () {
      test('should load wallet successfully', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
          name: 'Test Wallet',
        );
        
        // Provide dummy value for the mock
        provideDummy<Result<Wallet>>(Result.success(tWallet));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));

        // Act
        await viewModel.loadWallet();

        // Assert
        expect(viewModel.wallet, tWallet);
        expect(viewModel.isLoadingWallet, false);
        expect(viewModel.walletErrorMessage, isNull);
        verify(mockGetWallet.call()).called(1);
      });

      test('should handle wallet loading error', () async {
        // Arrange
        final failure = ServerFailure('error');
        provideDummy<Result<Wallet>>(Result.failure(failure));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadWallet();

        // Assert
        expect(viewModel.wallet, isNull);
        expect(viewModel.isLoadingWallet, false);
        expect(viewModel.walletErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetWallet.call()).called(1);
      });
    });

    group('Load Transaction History', () {
      test('should load transaction history successfully', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        final tTransaction = Transaction(
          id: 'tx1',
          type: TransactionType.send,
          amount: 10.0,
          fromAddress: 'sender_address',
          toAddress: 'receiver_address',
          timestamp: DateTime.now(),
          status: TransactionStatus.completed,
        );
        
        // Set up wallet first
        provideDummy<Result<Wallet>>(Result.success(tWallet));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        await viewModel.loadWallet();
        
        provideDummy<Result<List<Transaction>>>(Result.success([tTransaction]));
        when(mockGetTransactionHistory.call(any))
            .thenAnswer((_) async => Result.success([tTransaction]));

        // Act
        await viewModel.loadTransactionHistory();

        // Assert
        expect(viewModel.transactions, [tTransaction]);
        expect(viewModel.isLoadingTransactions, false);
        expect(viewModel.transactionsErrorMessage, isNull);
        verify(mockGetTransactionHistory.call(any)).called(1);
      });

      test('should handle transaction history loading error', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        final failure = NetworkFailure('error');
        
        // Set up wallet first
        provideDummy<Result<Wallet>>(Result.success(tWallet));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        await viewModel.loadWallet();
        
        provideDummy<Result<List<Transaction>>>(Result.failure(failure));
        when(mockGetTransactionHistory.call(any))
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadTransactionHistory();

        // Assert
        expect(viewModel.transactions, isEmpty);
        expect(viewModel.isLoadingTransactions, false);
        expect(viewModel.transactionsErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetTransactionHistory.call(any)).called(1);
      });
    });

    group('Send Transaction', () {
      test('should send transaction successfully', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        final tTransaction = Transaction(
          id: 'tx1',
          type: TransactionType.send,
          amount: 10.0,
          fromAddress: 'mock_address',
          toAddress: 'recipient_address',
          timestamp: DateTime.now(),
          status: TransactionStatus.completed,
        );
        
        // Set up wallet first
        provideDummy<Result<Wallet>>(Result.success(tWallet));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        await viewModel.loadWallet();

        provideDummy<Result<Transaction>>(Result.success(tTransaction));
        when(mockSendTransaction.call(any))
            .thenAnswer((_) async => Result.success(tTransaction));

        // Act
        final result = await viewModel.sendTransaction(
          toAddress: 'recipient_address',
          amount: 10.0,
          note: 'Test transaction',
        );

        // Assert
        expect(result, true);
        expect(viewModel.isSendingTransaction, false);
        expect(viewModel.sendErrorMessage, isNull);
        verify(mockSendTransaction.call(any)).called(1);
      });

      test('should handle send transaction error', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        
        // Set up wallet first
        provideDummy<Result<Wallet>>(Result.success(tWallet));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        await viewModel.loadWallet();

        final failure = ValidationFailure('error');
        provideDummy<Result<Transaction>>(Result.failure(failure));
        when(mockSendTransaction.call(any))
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        final result = await viewModel.sendTransaction(
          toAddress: 'recipient_address',
          amount: 10.0,
          note: 'Test transaction',
        );

        // Assert
        expect(result, false);
        expect(viewModel.isSendingTransaction, false);
        expect(viewModel.sendErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockSendTransaction.call(any)).called(1);
      });
    });

    group('Refresh Wallet', () {
      test('should refresh wallet and transaction history', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        final tTransaction = Transaction(
          id: 'tx1',
          type: TransactionType.send,
          amount: 10.0,
          fromAddress: 'mock_address',
          toAddress: 'recipient_address',
          timestamp: DateTime.now(),
          status: TransactionStatus.completed,
        );

        provideDummy<Result<Wallet>>(Result.success(tWallet));
        provideDummy<Result<List<Transaction>>>(Result.success([tTransaction]));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        when(mockGetTransactionHistory.call(any))
            .thenAnswer((_) async => Result.success([tTransaction]));

        // Act
        await viewModel.refreshWallet();

        // Assert
        expect(viewModel.wallet, tWallet);
        expect(viewModel.transactions, [tTransaction]);
        verify(mockGetWallet.call()).called(1);
        verify(mockGetTransactionHistory.call(any)).called(1);
      });
    });

    group('Utility Methods', () {
      test('should get formatted wallet address', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'ALGORAND123456789012345678901234567890123456789012345678901234567890',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        provideDummy<Result<Wallet>>(Result.success(tWallet));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        await viewModel.loadWallet();

        // Act
        final formattedAddress = viewModel.getFormattedWalletAddress();

        // Assert
        expect(formattedAddress, isNotNull);
        expect(formattedAddress, contains('...'));
      });

      test('should get recent transactions', () async {
        // Arrange
        final tWallet = Wallet(
          address: 'mock_address',
          balance: 100.0,
          balanceInUSD: 25.0,
        );
        final tTransactions = List.generate(10, (index) => Transaction(
          id: 'tx$index',
          type: TransactionType.send,
          amount: 10.0,
          fromAddress: 'mock_address',
          toAddress: 'recipient_address',
          timestamp: DateTime.now().subtract(Duration(minutes: index)),
          status: TransactionStatus.completed,
        ));

        provideDummy<Result<Wallet>>(Result.success(tWallet));
        provideDummy<Result<List<Transaction>>>(Result.success(tTransactions));
        when(mockGetWallet.call())
            .thenAnswer((_) async => Result.success(tWallet));
        when(mockGetTransactionHistory.call(any))
            .thenAnswer((_) async => Result.success(tTransactions));
        await viewModel.refreshWallet();

        // Act
        final recentTransactions = viewModel.getRecentTransactions();

        // Assert
        expect(recentTransactions.length, 5);
      });
    });
  });
}
