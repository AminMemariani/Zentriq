import '../entities/nft.dart';
import '../../core/utils/result.dart';

/// Repository interface for NFT operations
abstract class NftRepository {
  /// Fetches all NFTs owned by the user
  Future<Result<List<Nft>>> getAllNfts();

  /// Fetches NFTs by collection
  Future<Result<List<Nft>>> getNftsByCollection(String collection);

  /// Fetches a specific NFT by ID
  Future<Result<Nft>> getNftById(String nftId);

  /// Sends an NFT to another address
  Future<Result<NftTransaction>> sendNft({
    required String nftId,
    required String toAddress,
    String? note,
  });

  /// Updates NFT hidden status
  Future<Result<void>> updateNftHiddenStatus({
    required String nftId,
    required bool isHidden,
  });

  /// Reports an NFT as suspicious
  Future<Result<void>> reportNftAsSuspicious({
    required String nftId,
    required String reason,
  });

  /// Gets NFT transaction history
  Future<Result<List<NftTransaction>>> getNftTransactionHistory({
    String? nftId,
    int? limit,
  });
}
