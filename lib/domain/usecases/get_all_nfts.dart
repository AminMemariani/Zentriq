import '../entities/nft.dart';
import '../repositories/nft_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Use case for fetching all NFTs
class GetAllNfts implements UseCase<List<Nft>, NoParams> {
  const GetAllNfts(this.repository);

  final NftRepository repository;

  @override
  Future<Result<List<Nft>>> call(NoParams params) async {
    return await repository.getAllNfts();
  }
}
