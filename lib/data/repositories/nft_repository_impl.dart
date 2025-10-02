import '../../domain/entities/nft.dart';
import '../../domain/repositories/nft_repository.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart';
import '../services/nft_service.dart';

/// Implementation of NFT repository
class NftRepositoryImpl implements NftRepository {
  const NftRepositoryImpl({
    required this.nftService,
  });

  final NftService nftService;

  @override
  Future<Result<List<Nft>>> getAllNfts() async {
    try {
      final nfts = await nftService.getAllNfts();
      return Result.success(nfts);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch NFTs: $e'));
    }
  }

  @override
  Future<Result<List<Nft>>> getNftsByCollection(String collection) async {
    try {
      final nfts = await nftService.getNftsByCollection(collection);
      return Result.success(nfts);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch NFTs by collection: $e'));
    }
  }

  @override
  Future<Result<Nft>> getNftById(String nftId) async {
    try {
      final nft = await nftService.getNftById(nftId);
      if (nft == null) {
        return Result.failure(NotFoundFailure('NFT not found: $nftId'));
      }
      return Result.success(nft);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch NFT: $e'));
    }
  }

  @override
  Future<Result<NftTransaction>> sendNft({
    required String nftId,
    required String toAddress,
    String? note,
  }) async {
    try {
      // Validate address format (basic validation)
      if (toAddress.length < 32) {
        return Result.failure(ValidationFailure('Invalid Algorand address format'));
      }

      final transaction = await nftService.sendNft(
        nftId: nftId,
        toAddress: toAddress,
        note: note,
      );

      return Result.success(transaction);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to send NFT: $e'));
    }
  }

  @override
  Future<Result<void>> updateNftHiddenStatus({
    required String nftId,
    required bool isHidden,
  }) async {
    try {
      await nftService.updateNftHiddenStatus(
        nftId: nftId,
        isHidden: isHidden,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to update NFT status: $e'));
    }
  }

  @override
  Future<Result<void>> reportNftAsSuspicious({
    required String nftId,
    required String reason,
  }) async {
    try {
      await nftService.reportNftAsSuspicious(
        nftId: nftId,
        reason: reason,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to report NFT: $e'));
    }
  }

  @override
  Future<Result<List<NftTransaction>>> getNftTransactionHistory({
    String? nftId,
    int? limit,
  }) async {
    try {
      final transactions = await nftService.getNftTransactionHistory(
        nftId: nftId,
        limit: limit,
      );
      return Result.success(transactions);
    } catch (e) {
      return Result.failure(ServerFailure('Failed to fetch transaction history: $e'));
    }
  }
}
