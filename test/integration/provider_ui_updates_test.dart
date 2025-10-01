import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:zentriq/core/errors/failures.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/domain/entities/wallet.dart';
import 'package:zentriq/domain/entities/transaction.dart';
import 'package:zentriq/domain/usecases/get_transaction_history.dart';
import 'package:zentriq/domain/usecases/get_wallet.dart';
import 'package:zentriq/domain/usecases/send_transaction.dart';
import 'package:zentriq/viewmodels/wallet_viewmodel.dart';
import 'package:zentriq/views/screens/wallet_screen.dart';

import '../mocks/mock_repositories.mocks.dart';

void main() {
  group('Provider UI Updates', () {
    testWidgets('Wallet screen updates when ViewModel changes', (
      WidgetTester tester,
    ) async {
      // Create mock use cases
      final mockGetWallet = MockGetWallet();
      final mockGetTransactionHistory = MockGetTransactionHistory();
      final mockSendTransaction = MockSendTransaction();

      // Create a test ViewModel
      final viewModel = WalletViewModel(
        mockGetWallet,
        mockGetTransactionHistory,
        mockSendTransaction,
      );

      // Set up mock responses with dummy values
      final testWallet = Wallet(
        address: 'test_address',
        balance: 100.0,
        balanceInUSD: 25.0,
        name: 'Test Wallet',
      );
      
      provideDummy<Result<Wallet>>(Result.success(testWallet));
      provideDummy<Result<List<Transaction>>>(Result.success([]));
      
      when(mockGetWallet.call())
          .thenAnswer((_) async => Result.success(testWallet));
      when(mockGetTransactionHistory.call(any))
          .thenAnswer((_) async => Result.success([]));

      // Create test widget
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WalletViewModel>.value(
            value: viewModel,
            child: const WalletScreen(),
          ),
        ),
      );

      // Wait for initial build
      await tester.pumpAndSettle();

      // Verify UI elements are present
      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('100.00 ALGO'), findsOneWidget);
      expect(find.text('\$25.00 USD'), findsOneWidget);
    });

    testWidgets('Provider notifies listeners when ViewModel changes', (
      WidgetTester tester,
    ) async {
      // Create mock use cases
      final mockGetWallet = MockGetWallet();
      final mockGetTransactionHistory = MockGetTransactionHistory();
      final mockSendTransaction = MockSendTransaction();

      // Create a test ViewModel
      final viewModel = WalletViewModel(
        mockGetWallet,
        mockGetTransactionHistory,
        mockSendTransaction,
      );

      bool listenerCalled = false;
      viewModel.addListener(() {
        listenerCalled = true;
      });

      // Set up mock responses with dummy values
      final testWallet = Wallet(
        address: 'test_address',
        balance: 100.0,
        balanceInUSD: 25.0,
        name: 'Test Wallet',
      );
      
      provideDummy<Result<Wallet>>(Result.success(testWallet));
      when(mockGetWallet.call())
          .thenAnswer((_) async => Result.success(testWallet));

      // Trigger a state change
      await viewModel.loadWallet();

      // Verify listener was called
      expect(listenerCalled, isTrue);
    });
  });
}
