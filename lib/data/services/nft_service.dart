import 'dart:math';
import '../../domain/entities/nft.dart';
import '../models/nft_model.dart';

/// Service for fetching NFT data from various sources
class NftService {
  // Mock blacklisted creator addresses for scam detection
  static const List<String> _blacklistedCreators = [
    'SCAM123456789',
    'FAKE_CREATOR_001',
    'SUSPICIOUS_ADDR',
  ];

  // Mock suspicious collections
  static const List<String> _suspiciousCollections = [
    'Fake Collection',
    'Scam NFTs',
    'Suspicious Art',
  ];

  /// Fetches all NFTs owned by the user (mocked data)
  Future<List<NftModel>> getAllNfts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _generateMockNfts();
  }

  /// Fetches NFTs by collection (mocked data)
  Future<List<NftModel>> getNftsByCollection(String collection) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allNfts = _generateMockNfts();
    return allNfts.where((nft) => nft.collection == collection).toList();
  }

  /// Fetches a specific NFT by ID (mocked data)
  Future<NftModel?> getNftById(String nftId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final allNfts = _generateMockNfts();
    try {
      return allNfts.firstWhere((nft) => nft.id == nftId);
    } catch (e) {
      return null;
    }
  }

  /// Sends an NFT to another address (mocked transaction)
  Future<NftTransaction> sendNft({
    required String nftId,
    required String toAddress,
    String? note,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return NftTransaction(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      nftId: nftId,
      fromAddress: 'USER_WALLET_ADDRESS',
      toAddress: toAddress,
      amount: 1,
      timestamp: DateTime.now(),
      note: note,
      fee: 0.001,
      status: NftTransactionStatus.completed,
    );
  }

  /// Updates NFT hidden status (mocked)
  Future<void> updateNftHiddenStatus({
    required String nftId,
    required bool isHidden,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // In a real implementation, this would update the local database
  }

  /// Reports an NFT as suspicious (mocked)
  Future<void> reportNftAsSuspicious({
    required String nftId,
    required String reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In a real implementation, this would send a report to a moderation system
  }

  /// Gets NFT transaction history (mocked data)
  Future<List<NftTransaction>> getNftTransactionHistory({
    String? nftId,
    int? limit = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _generateMockTransactions(nftId: nftId, limit: limit);
  }

  /// Generates mock NFT data
  List<NftModel> _generateMockNfts() {
    final random = Random();
    final collections = [
      'Algorand Punks',
      'Algo Apes',
      'Algorand Art',
      'Fake Collection', // Suspicious collection
      'Digital Dreams',
      'Blockchain Beasts',
      'Scam NFTs', // Suspicious collection
    ];

    final creators = [
      'CREATOR_001',
      'CREATOR_002',
      'SCAM123456789', // Blacklisted creator
      'CREATOR_003',
      'FAKE_CREATOR_001', // Blacklisted creator
      'CREATOR_004',
      'SUSPICIOUS_ADDR', // Blacklisted creator
    ];

    final nfts = <NftModel>[];

    for (int i = 1; i <= 20; i++) {
      final collection = collections[random.nextInt(collections.length)];
      final creator = creators[random.nextInt(creators.length)];
      final mintPrice = random.nextDouble() * 10; // 0-10 ALGO
      
      // Determine if NFT is suspicious
      final isScam = _blacklistedCreators.contains(creator) ||
          _suspiciousCollections.contains(collection) ||
          mintPrice < 0.001; // Very low mint price

      String? scamReason;
      if (isScam) {
        if (_blacklistedCreators.contains(creator)) {
          scamReason = 'Blacklisted creator address';
        } else if (_suspiciousCollections.contains(collection)) {
          scamReason = 'Suspicious collection name';
        } else if (mintPrice < 0.001) {
          scamReason = 'Unusually low mint price';
        }
      }

      nfts.add(NftModel(
        id: 'nft_$i',
        name: 'NFT #$i',
        description: 'This is a unique digital collectible from the $collection series. Each NFT represents a piece of digital art with unique properties and characteristics.',
        imageUrl: 'https://picsum.photos/400/400?random=$i',
        creator: creator,
        owner: 'USER_WALLET_ADDRESS',
        tokenId: i,
        assetId: 1000000 + i,
        collection: collection,
        mintPrice: mintPrice,
        mintDate: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        attributes: {
          'rarity': ['Common', 'Rare', 'Epic', 'Legendary'][random.nextInt(4)],
          'color': ['Red', 'Blue', 'Green', 'Purple', 'Gold'][random.nextInt(5)],
          'power': random.nextInt(100),
        },
        externalUrl: 'https://example.com/nft/$i',
        isScam: isScam,
        scamReason: scamReason,
        isHidden: false,
      ));
    }

    return nfts;
  }

  /// Generates mock transaction data
  List<NftTransaction> _generateMockTransactions({
    String? nftId,
    int? limit,
  }) {
    final random = Random();
    final transactions = <NftTransaction>[];

    for (int i = 1; i <= (limit ?? 10); i++) {
      transactions.add(NftTransaction(
        id: 'tx_$i',
        nftId: nftId ?? 'nft_${random.nextInt(20) + 1}',
        fromAddress: 'FROM_ADDRESS_$i',
        toAddress: 'TO_ADDRESS_$i',
        amount: 1,
        timestamp: DateTime.now().subtract(Duration(hours: random.nextInt(168))), // Last week
        note: 'NFT transfer #$i',
        fee: 0.001,
        status: NftTransactionStatus.completed,
      ));
    }

    return transactions;
  }
}
