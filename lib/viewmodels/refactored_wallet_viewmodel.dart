import 'package:flutter/foundation.dart';
import '../domain/entities/wallet.dart';
import '../domain/entities/transaction.dart';
import '../domain/usecases/get_wallet.dart';
import '../domain/usecases/get_transaction_history.dart';
import '../domain/usecases/send_transaction.dart';
import '../core/viewmodels/base_viewmodel.dart';
import '../core/utils/result.dart';
import '../core/errors/failures.dart' as failures;

/// Refactored ViewModel for wallet-related operations with improved scalability
class RefactoredWalletViewModel extends BaseViewModel {
  RefactoredWalletViewModel(
    this._getWallet,
    this._getTransactionHistory,
    this._sendTransaction,
  );

  final GetWallet _getWallet;
  final GetTransactionHistory _getTransactionHistory;
  final SendTransaction _sendTransaction;

  // Wallet state
  Wallet? _wallet;
  bool _isLoadingWallet = false;
  String? _walletErrorMessage;

  // Transaction history state
  List<Transaction> _transactions = [];
  bool _isLoadingTransactions = false;
  String? _transactionsErrorMessage;

  // Send transaction state
  bool _isSendingTransaction = false;
  String? _sendErrorMessage;

  // Getters
  Wallet? get wallet => _wallet;
  bool get isLoadingWallet => _isLoadingWallet;
  String? get walletErrorMessage => _walletErrorMessage;
  bool get hasWalletError => _walletErrorMessage != null;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get transactionsErrorMessage => _transactionsErrorMessage;
  bool get hasTransactionsError => _transactionsErrorMessage != null;

  bool get isSendingTransaction => _isSendingTransaction;
  String? get sendErrorMessage => _sendErrorMessage;
  bool get hasSendError => _sendErrorMessage != null;

  /// Loads the current wallet
  Future<void> loadWallet() async {
    await executeResultOperation(
      () => _getWallet(),
      onSuccess: (wallet) {
        _wallet = wallet;
        _walletErrorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Loads transaction history
  Future<void> loadTransactionHistory() async {
    await executeResultOperation(
      () => _getTransactionHistory(),
      onSuccess: (transactions) {
        _transactions = transactions;
        _transactionsErrorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Refreshes both wallet and transaction history
  Future<void> refreshWallet() async {
    await Future.wait([loadWallet(), loadTransactionHistory()]);
  }

  /// Sends a transaction
  Future<bool> sendTransaction({
    required String recipient,
    required int amount,
    String? note,
  }) async {
    final result = await executeResultOperation(
      () => _sendTransaction(
        SendTransactionParams(recipient: recipient, amount: amount, note: note),
      ),
      onSuccess: (transactionId) {
        _sendErrorMessage = null;
        // Refresh wallet and transactions after successful send
        refreshWallet();
        return true;
      },
    );

    return result != null;
  }

  /// Gets formatted wallet address for display
  String? getFormattedWalletAddress() {
    if (_wallet == null) return null;

    final address = _wallet!.address;
    if (address.length <= 12) return address;

    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }

  /// Gets recent transactions (last 10)
  List<Transaction> getRecentTransactions({int limit = 10}) {
    final sortedTransactions = List<Transaction>.from(_transactions);
    sortedTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedTransactions.take(limit).toList();
  }

  /// Gets transactions by type
  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactions.where((tx) => tx.type == type).toList();
  }

  /// Gets total sent amount
  int getTotalSent() {
    return _transactions
        .where((tx) => tx.type == TransactionType.send)
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  /// Gets total received amount
  int getTotalReceived() {
    return _transactions
        .where((tx) => tx.type == TransactionType.receive)
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  /// Gets total transaction fees
  int getTotalFees() {
    return _transactions.fold(0, (sum, tx) => sum + tx.fee);
  }

  /// Checks if wallet has sufficient balance for a transaction
  bool hasSufficientBalance(int amount, int fee) {
    if (_wallet == null) return false;
    return _wallet!.balance >= (amount + fee);
  }

  /// Validates a recipient address
  bool isValidRecipient(String address) {
    // Basic Algorand address validation
    if (address.length != 58) return false;
    return RegExp(r'^[A-Z2-7]+$').hasMatch(address);
  }

  /// Clears all error states
  void clearAllErrors() {
    _walletErrorMessage = null;
    _transactionsErrorMessage = null;
    _sendErrorMessage = null;
    notifyListeners();
  }

  /// Resets all state
  void reset() {
    _wallet = null;
    _transactions.clear();
    _walletErrorMessage = null;
    _transactionsErrorMessage = null;
    _sendErrorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// Parameters for sending a transaction
class SendTransactionParams {
  final String recipient;
  final int amount;
  final String? note;

  const SendTransactionParams({
    required this.recipient,
    required this.amount,
    this.note,
  });
}
