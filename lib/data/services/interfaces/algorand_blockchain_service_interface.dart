import '../../../../core/utils/result.dart';

/// Abstract interface for Algorand blockchain operations
abstract class AlgorandBlockchainServiceInterface {
  /// Fetches account information including balance
  Future<Result<Map<String, dynamic>>> getAccountInfo(String address);

  /// Fetches account balance in microALGOs
  Future<Result<int>> getAccountBalance(String address);

  /// Fetches transaction history for an account
  Future<Result<List<Map<String, dynamic>>>> getTransactionHistory(
    String address, {
    int limit = 50,
    String? nextToken,
  });

  /// Fetches asset information
  Future<Result<Map<String, dynamic>>> getAssetInfo(int assetId);

  /// Fetches account's asset holdings
  Future<Result<List<Map<String, dynamic>>>> getAccountAssets(String address);

  /// Sends a transaction
  Future<Result<String>> sendTransaction(String signedTransaction);

  /// Fetches network status and health
  Future<Result<Map<String, dynamic>>> getNetworkStatus();

  /// Fetches block information
  Future<Result<Map<String, dynamic>>> getBlockInfo(int round);

  /// Fetches current network parameters
  Future<Result<Map<String, dynamic>>> getNetworkParameters();

  /// Validates an Algorand address
  bool isValidAddress(String address);

  /// Converts microALGOs to ALGOs
  double microAlgosToAlgos(int microAlgos);

  /// Converts ALGOs to microALGOs
  int algosToMicroAlgos(double algos);
}
