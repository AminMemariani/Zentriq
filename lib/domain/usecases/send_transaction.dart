import '../entities/transaction.dart';
import '../repositories/wallet_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for sending a transaction
class SendTransactionParams {
  const SendTransactionParams({
    required this.toAddress,
    required this.amount,
    this.note,
  });

  final String toAddress;
  final double amount;
  final String? note;
}

/// Use case for sending a transaction
class SendTransaction extends UseCase<Transaction, SendTransactionParams> {
  SendTransaction(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<Transaction>> call(SendTransactionParams params) {
    return _repository.sendTransaction(
      toAddress: params.toAddress,
      amount: params.amount,
      note: params.note,
    );
  }
}
