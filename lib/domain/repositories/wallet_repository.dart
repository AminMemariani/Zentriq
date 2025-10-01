import '../entities/wallet.dart';
import '../entities/transaction.dart';
import '../../core/utils/result.dart';

/// Abstract repository for wallet-related operations
abstract class WalletRepository {
  /// Gets the current wallet
  Future<Result<Wallet>> getCurrentWallet();

  /// Gets wallet balance
  Future<Result<double>> getWalletBalance(String address);

  /// Gets wallet balance in USD
  Future<Result<double>> getWalletBalanceUSD(String address);

  /// Gets transaction history for a wallet
  Future<Result<List<Transaction>>> getTransactionHistory(String address);

  /// Sends a transaction
  Future<Result<Transaction>> sendTransaction({
    required String toAddress,
    required double amount,
    String? note,
  });

  /// Generates a new wallet address
  Future<Result<String>> generateNewAddress();

  /// Refreshes wallet data
  Future<Result<Wallet>> refreshWallet(String address);
}
