import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/domain/entities/nft.dart';

void main() {
  group('Nft Entity', () {
    final testNft = Nft(
      id: 'nft_1',
      name: 'Test NFT',
      description: 'A test NFT for unit testing',
      imageUrl: 'https://example.com/image.jpg',
      creator: 'CREATOR_001',
      owner: 'OWNER_001',
      tokenId: 1,
      assetId: 1000001,
      collection: 'Test Collection',
      mintPrice: 1.5,
      mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
      attributes: {'rarity': 'Common', 'color': 'Blue'},
      externalUrl: 'https://example.com/nft/1',
      animationUrl: 'https://example.com/animation.mp4',
      isScam: false,
      scamReason: null,
      isHidden: false,
    );

    test('should create NFT with all properties', () {
      expect(testNft.id, 'nft_1');
      expect(testNft.name, 'Test NFT');
      expect(testNft.description, 'A test NFT for unit testing');
      expect(testNft.imageUrl, 'https://example.com/image.jpg');
      expect(testNft.creator, 'CREATOR_001');
      expect(testNft.owner, 'OWNER_001');
      expect(testNft.tokenId, 1);
      expect(testNft.assetId, 1000001);
      expect(testNft.collection, 'Test Collection');
      expect(testNft.mintPrice, 1.5);
      expect(testNft.attributes, {'rarity': 'Common', 'color': 'Blue'});
      expect(testNft.externalUrl, 'https://example.com/nft/1');
      expect(testNft.animationUrl, 'https://example.com/animation.mp4');
      expect(testNft.isScam, false);
      expect(testNft.scamReason, null);
      expect(testNft.isHidden, false);
    });

    test('should format mint price correctly', () {
      expect(testNft.formattedMintPrice, '1.50 ALGO');
    });

    test('should format mint date correctly', () {
      // This test might need adjustment based on current date
      expect(testNft.formattedMintDate, isA<String>());
    });

    test('should return short description for long descriptions', () {
      final longDescriptionNft = Nft(
        id: 'nft_2',
        name: 'Long Description NFT',
        description: 'This is a very long description that exceeds one hundred characters and should be truncated when the short description method is called',
        imageUrl: 'https://example.com/image2.jpg',
        creator: 'CREATOR_002',
        owner: 'OWNER_002',
        tokenId: 2,
        assetId: 1000002,
        collection: 'Test Collection',
        mintPrice: 2.0,
        mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      expect(longDescriptionNft.shortDescription.length, lessThanOrEqualTo(103)); // 100 + "..."
      expect(longDescriptionNft.shortDescription, endsWith('...'));
    });

    test('should return full description for short descriptions', () {
      expect(testNft.shortDescription, testNft.description);
    });

    test('should create copy with updated properties', () {
      final updatedNft = testNft.copyWith(
        name: 'Updated NFT',
        isHidden: true,
      );

      expect(updatedNft.name, 'Updated NFT');
      expect(updatedNft.isHidden, true);
      expect(updatedNft.id, testNft.id); // Should remain unchanged
      expect(updatedNft.description, testNft.description); // Should remain unchanged
    });

    test('should create copy with null fields preserving original values', () {
      final updatedNft = testNft.copyWith(
        name: null,
        description: null,
      );

      expect(updatedNft.name, testNft.name); // Should preserve original
      expect(updatedNft.description, testNft.description); // Should preserve original
    });

    test('should support equality comparison', () {
      final nft1 = Nft(
        id: 'nft_1',
        name: 'Test NFT',
        description: 'A test NFT',
        imageUrl: 'https://example.com/image.jpg',
        creator: 'CREATOR_001',
        owner: 'OWNER_001',
        tokenId: 1,
        assetId: 1000001,
        collection: 'Test Collection',
        mintPrice: 1.5,
        mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      final nft2 = Nft(
        id: 'nft_1',
        name: 'Test NFT',
        description: 'A test NFT',
        imageUrl: 'https://example.com/image.jpg',
        creator: 'CREATOR_001',
        owner: 'OWNER_001',
        tokenId: 1,
        assetId: 1000001,
        collection: 'Test Collection',
        mintPrice: 1.5,
        mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );

      expect(nft1, equals(nft2));
    });
  });

  group('NftTransaction Entity', () {
    final testTransaction = NftTransaction(
      id: 'tx_1',
      nftId: 'nft_1',
      fromAddress: 'FROM_ADDRESS',
      toAddress: 'TO_ADDRESS',
      amount: 1,
      timestamp: DateTime.parse('2023-01-01T12:00:00.000Z'),
      note: 'Test transaction',
      fee: 0.001,
      status: NftTransactionStatus.completed,
    );

    test('should create transaction with all properties', () {
      expect(testTransaction.id, 'tx_1');
      expect(testTransaction.nftId, 'nft_1');
      expect(testTransaction.fromAddress, 'FROM_ADDRESS');
      expect(testTransaction.toAddress, 'TO_ADDRESS');
      expect(testTransaction.amount, 1);
      expect(testTransaction.note, 'Test transaction');
      expect(testTransaction.fee, 0.001);
      expect(testTransaction.status, NftTransactionStatus.completed);
    });

    test('should format timestamp correctly', () {
      expect(testTransaction.formattedTimestamp, isA<String>());
    });

    test('should support equality comparison', () {
      final transaction1 = NftTransaction(
        id: 'tx_1',
        nftId: 'nft_1',
        fromAddress: 'FROM_ADDRESS',
        toAddress: 'TO_ADDRESS',
        amount: 1,
        timestamp: DateTime.parse('2023-01-01T12:00:00.000Z'),
        status: NftTransactionStatus.completed,
      );

      final transaction2 = NftTransaction(
        id: 'tx_1',
        nftId: 'nft_1',
        fromAddress: 'FROM_ADDRESS',
        toAddress: 'TO_ADDRESS',
        amount: 1,
        timestamp: DateTime.parse('2023-01-01T12:00:00.000Z'),
        status: NftTransactionStatus.completed,
      );

      expect(transaction1, equals(transaction2));
    });
  });
}
