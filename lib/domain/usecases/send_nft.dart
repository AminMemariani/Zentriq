import '../entities/nft.dart';
import '../repositories/nft_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for sending an NFT
class SendNftParams {
  const SendNftParams({
    required this.nftId,
    required this.toAddress,
    this.note,
  });

  final String nftId;
  final String toAddress;
  final String? note;
}

/// Use case for sending an NFT
class SendNft implements UseCase<NftTransaction, SendNftParams> {
  const SendNft(this.repository);

  final NftRepository repository;

  @override
  Future<Result<NftTransaction>> call(SendNftParams params) async {
    return await repository.sendNft(
      nftId: params.nftId,
      toAddress: params.toAddress,
      note: params.note,
    );
  }
}
