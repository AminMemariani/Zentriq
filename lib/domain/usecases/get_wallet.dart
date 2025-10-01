import '../entities/wallet.dart';
import '../repositories/wallet_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Use case for getting the current wallet
class GetWallet extends UseCaseNoParams<Wallet> {
  GetWallet(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<Wallet>> call() {
    return _repository.getCurrentWallet();
  }
}
