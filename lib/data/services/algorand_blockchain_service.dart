import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart' as failures;
import 'interfaces/algorand_blockchain_service_interface.dart';

/// Algorand blockchain service for interacting with Algorand RPC nodes
class AlgorandBlockchainService implements AlgorandBlockchainServiceInterface {
  AlgorandBlockchainService({
    this.baseUrl = 'https://mainnet-api.algonode.cloud',
    this.indexerUrl = 'https://mainnet-idx.algonode.cloud',
    this.apiKey,
  });

  final String baseUrl;
  final String indexerUrl;
  final String? apiKey;

  /// Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (apiKey != null) 'X-API-Key': apiKey!,
  };

  /// Fetches account information including balance
  @override
  Future<Result<Map<String, dynamic>>> getAccountInfo(String address) async {
    try {
      final url = Uri.parse('$indexerUrl/v2/accounts/$address');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch account info: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches account balance in microALGOs
  @override
  Future<Result<int>> getAccountBalance(String address) async {
    try {
      final accountResult = await getAccountInfo(address);
      if (accountResult.isSuccess) {
        final data = accountResult.data!;
        final balance = data['account']?['amount'] as int? ?? 0;
        return Result.success(balance);
      } else {
        return Result.failure(accountResult.failure!);
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches transaction history for an account
  @override
  Future<Result<List<Map<String, dynamic>>>> getTransactionHistory(
    String address, {
    int limit = 50,
    String? nextToken,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'address': address,
      };
      if (nextToken != null) {
        queryParams['next'] = nextToken;
      }

      final url = Uri.parse(
        '$indexerUrl/v2/accounts/$address/transactions',
      ).replace(queryParameters: queryParams);
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final transactions =
            (data['transactions'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>() ??
            [];
        return Result.success(transactions);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch transactions: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches asset information
  @override
  Future<Result<Map<String, dynamic>>> getAssetInfo(int assetId) async {
    try {
      final url = Uri.parse('$indexerUrl/v2/assets/$assetId');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch asset info: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches account's asset holdings
  @override
  Future<Result<List<Map<String, dynamic>>>> getAccountAssets(
    String address,
  ) async {
    try {
      final url = Uri.parse('$indexerUrl/v2/accounts/$address/assets');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final assets =
            (data['assets'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            [];
        return Result.success(assets);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch account assets: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Sends a transaction (placeholder for future implementation)
  @override
  Future<Result<String>> sendTransaction(String signedTransaction) async {
    try {
      // TODO: Implement actual transaction sending
      // This would involve:
      // 1. Validating the signed transaction
      // 2. Broadcasting to the network
      // 3. Waiting for confirmation

      // For now, return a mock transaction ID
      await Future.delayed(const Duration(seconds: 2));
      return Result.success(
        'MOCK_TX_ID_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  /// Fetches network status and health
  @override
  Future<Result<Map<String, dynamic>>> getNetworkStatus() async {
    try {
      final url = Uri.parse('$indexerUrl/v2/status');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch network status: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches block information
  @override
  Future<Result<Map<String, dynamic>>> getBlockInfo(int round) async {
    try {
      final url = Uri.parse('$indexerUrl/v2/blocks/$round');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch block info: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Fetches current network parameters
  @override
  Future<Result<Map<String, dynamic>>> getNetworkParameters() async {
    try {
      final url = Uri.parse('$baseUrl/v2/params');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Result.success(data);
      } else {
        return Result.failure(
          failures.ServerFailure(
            'Failed to fetch network parameters: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      return Result.failure(failures.NetworkFailure(e.toString()));
    }
  }

  /// Validates an Algorand address
  @override
  bool isValidAddress(String address) {
    // Algorand addresses are 58 characters long and use base32 encoding
    if (address.length != 58) return false;

    // Check if it contains only valid base32 characters
    final validChars = RegExp(r'^[A-Z2-7]+$');
    return validChars.hasMatch(address);
  }

  /// Converts microALGOs to ALGOs
  @override
  double microAlgosToAlgos(int microAlgos) {
    return microAlgos / 1000000.0;
  }

  /// Converts ALGOs to microALGOs
  @override
  int algosToMicroAlgos(double algos) {
    return (algos * 1000000).round();
  }
}
