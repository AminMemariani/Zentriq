import 'package:flutter/foundation.dart';
import '../domain/entities/wallet.dart';
import '../domain/entities/transaction.dart';
import '../domain/usecases/get_wallet.dart';
import '../domain/usecases/get_transaction_history.dart';
import '../domain/usecases/send_transaction.dart';
import '../core/errors/failures.dart' as failures;

/// ViewModel for wallet-related operations using Provider
class WalletViewModel extends ChangeNotifier {
  WalletViewModel(
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

  List<Transaction> get transactions => _transactions;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get transactionsErrorMessage => _transactionsErrorMessage;
  bool get hasTransactionsError => _transactionsErrorMessage != null;

  bool get isSendingTransaction => _isSendingTransaction;
  String? get sendErrorMessage => _sendErrorMessage;
  bool get hasSendError => _sendErrorMessage != null;

  /// Loads the current wallet
  Future<void> loadWallet() async {
    _setWalletLoading(true);
    _clearWalletError();

    final result = await _getWallet();

    result
        .onSuccess((wallet) {
          _wallet = wallet;
          notifyListeners();
        })
        .onFailure((failure) {
          _setWalletError(_getErrorMessage(failure));
        });

    _setWalletLoading(false);
  }

  /// Loads transaction history for the current wallet
  Future<void> loadTransactionHistory() async {
    if (_wallet == null) return;

    _setTransactionsLoading(true);
    _clearTransactionsError();

    final result = await _getTransactionHistory(_wallet!.address);

    result
        .onSuccess((transactions) {
          _transactions = transactions;
          notifyListeners();
        })
        .onFailure((failure) {
          _setTransactionsError(_getErrorMessage(failure));
        });

    _setTransactionsLoading(false);
  }

  /// Refreshes wallet data
  Future<void> refreshWallet() async {
    await loadWallet();
    if (_wallet != null) {
      await loadTransactionHistory();
    }
  }

  /// Sends a transaction
  Future<bool> sendTransaction({
    required String toAddress,
    required double amount,
    String? note,
  }) async {
    if (_wallet == null) return false;

    _setSendingTransaction(true);
    _clearSendError();

    final params = SendTransactionParams(
      toAddress: toAddress,
      amount: amount,
      note: note,
    );

    final result = await _sendTransaction(params);

    bool success = false;
    result
        .onSuccess((transaction) {
          // Add the new transaction to the list
          _transactions.insert(0, transaction);
          // Update wallet balance (simplified - in real app, refresh from server)
          _wallet = _wallet!.copyWith(
            balance: _wallet!.balance - amount,
            balanceInUSD:
                _wallet!.balanceInUSD - (amount * 0.15), // Mock USD rate
            updatedAt: DateTime.now(),
          );
          success = true;
          notifyListeners();
        })
        .onFailure((failure) {
          _setSendError(_getErrorMessage(failure));
        });

    _setSendingTransaction(false);
    return success;
  }

  /// Generates a QR code for receiving payments
  String? getReceiveQRCode() {
    if (_wallet == null) return null;
    // In a real app, this would generate an actual QR code
    return 'algorand:${_wallet!.address}';
  }

  /// Copies wallet address to clipboard
  String? getWalletAddress() {
    return _wallet?.address;
  }

  /// Gets formatted wallet address
  String? getFormattedWalletAddress() {
    return _wallet?.formattedAddress;
  }

  /// Gets recent transactions (last 5)
  List<Transaction> getRecentTransactions() {
    return _transactions.take(5).toList();
  }

  // Private methods for state management
  void _setWalletLoading(bool loading) {
    _isLoadingWallet = loading;
    notifyListeners();
  }

  void _setWalletError(String message) {
    _walletErrorMessage = message;
    notifyListeners();
  }

  void _clearWalletError() {
    _walletErrorMessage = null;
  }

  void _setTransactionsLoading(bool loading) {
    _isLoadingTransactions = loading;
    notifyListeners();
  }

  void _setTransactionsError(String message) {
    _transactionsErrorMessage = message;
    notifyListeners();
  }

  void _clearTransactionsError() {
    _transactionsErrorMessage = null;
  }

  void _setSendingTransaction(bool sending) {
    _isSendingTransaction = sending;
    notifyListeners();
  }

  void _setSendError(String message) {
    _sendErrorMessage = message;
    notifyListeners();
  }

  void _clearSendError() {
    _sendErrorMessage = null;
  }

  /// Converts a failure to a user-friendly error message
  String _getErrorMessage(failures.Failure failure) {
    switch (failure.runtimeType) {
      case failures.NetworkFailure _:
        return 'No internet connection. Please check your network.';
      case failures.ServerFailure _:
        return 'Server error. Please try again later.';
      case failures.CacheFailure _:
        return 'Failed to load data from cache.';
      case failures.ValidationFailure _:
        return 'Invalid data. Please check your input.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
