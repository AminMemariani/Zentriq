import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Use case for getting transaction history
class GetTransactionHistory extends UseCase<List<Transaction>, String> {
  GetTransactionHistory(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<List<Transaction>>> call(String address) {
    return _repository.getTransactionHistory(address);
  }
}
