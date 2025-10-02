import '../repositories/nft_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for updating NFT visibility
class UpdateNftVisibilityParams {
  const UpdateNftVisibilityParams({
    required this.nftId,
    required this.isHidden,
  });

  final String nftId;
  final bool isHidden;
}

/// Use case for updating NFT visibility (hide/unhide)
class UpdateNftVisibility implements UseCase<void, UpdateNftVisibilityParams> {
  const UpdateNftVisibility(this.repository);

  final NftRepository repository;

  @override
  Future<Result<void>> call(UpdateNftVisibilityParams params) async {
    return await repository.updateNftHiddenStatus(
      nftId: params.nftId,
      isHidden: params.isHidden,
    );
  }
}
