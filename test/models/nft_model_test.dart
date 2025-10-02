import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/nft_model.dart';
import 'package:zentriq/domain/entities/nft.dart';

void main() {
  group('NftModel', () {
    const testJson = {
      'id': 'nft_1',
      'name': 'Test NFT',
      'description': 'A test NFT for unit testing',
      'image_url': 'https://example.com/image.jpg',
      'creator': 'CREATOR_001',
      'owner': 'OWNER_001',
      'token_id': 1,
      'asset_id': 1000001,
      'collection': 'Test Collection',
      'mint_price': 1.5,
      'mint_date': '2023-01-01T00:00:00.000Z',
      'attributes': {'rarity': 'Common', 'color': 'Blue'},
      'external_url': 'https://example.com/nft/1',
      'animation_url': 'https://example.com/animation.mp4',
      'is_scam': false,
      'scam_reason': null,
      'is_hidden': false,
    };

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

    test('should create NftModel from JSON', () {
      final nftModel = NftModel.fromJson(testJson);

      expect(nftModel.id, 'nft_1');
      expect(nftModel.name, 'Test NFT');
      expect(nftModel.description, 'A test NFT for unit testing');
      expect(nftModel.imageUrl, 'https://example.com/image.jpg');
      expect(nftModel.creator, 'CREATOR_001');
      expect(nftModel.owner, 'OWNER_001');
      expect(nftModel.tokenId, 1);
      expect(nftModel.assetId, 1000001);
      expect(nftModel.collection, 'Test Collection');
      expect(nftModel.mintPrice, 1.5);
      expect(nftModel.mintDate, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(nftModel.attributes, {'rarity': 'Common', 'color': 'Blue'});
      expect(nftModel.externalUrl, 'https://example.com/nft/1');
      expect(nftModel.animationUrl, 'https://example.com/animation.mp4');
      expect(nftModel.isScam, false);
      expect(nftModel.scamReason, null);
      expect(nftModel.isHidden, false);
    });

    test('should create NftModel from JSON with null optional fields', () {
      const jsonWithNulls = {
        'id': 'nft_2',
        'name': 'Test NFT 2',
        'description': 'Another test NFT',
        'image_url': 'https://example.com/image2.jpg',
        'creator': 'CREATOR_002',
        'owner': 'OWNER_002',
        'token_id': 2,
        'asset_id': 1000002,
        'collection': 'Test Collection',
        'mint_price': 2.0,
        'mint_date': '2023-01-01T00:00:00.000Z',
        'attributes': null,
        'external_url': null,
        'animation_url': null,
        'is_scam': true,
        'scam_reason': 'Suspicious metadata',
        'is_hidden': true,
      };

      final nftModel = NftModel.fromJson(jsonWithNulls);

      expect(nftModel.attributes, null);
      expect(nftModel.externalUrl, null);
      expect(nftModel.animationUrl, null);
      expect(nftModel.isScam, true);
      expect(nftModel.scamReason, 'Suspicious metadata');
      expect(nftModel.isHidden, true);
    });

    test('should convert NftModel to JSON', () {
      final nftModel = NftModel.fromJson(testJson);
      final json = nftModel.toJson();

      expect(json['id'], 'nft_1');
      expect(json['name'], 'Test NFT');
      expect(json['description'], 'A test NFT for unit testing');
      expect(json['image_url'], 'https://example.com/image.jpg');
      expect(json['creator'], 'CREATOR_001');
      expect(json['owner'], 'OWNER_001');
      expect(json['token_id'], 1);
      expect(json['asset_id'], 1000001);
      expect(json['collection'], 'Test Collection');
      expect(json['mint_price'], 1.5);
      expect(json['mint_date'], '2023-01-01T00:00:00.000Z');
      expect(json['attributes'], {'rarity': 'Common', 'color': 'Blue'});
      expect(json['external_url'], 'https://example.com/nft/1');
      expect(json['animation_url'], 'https://example.com/animation.mp4');
      expect(json['is_scam'], false);
      expect(json['scam_reason'], null);
      expect(json['is_hidden'], false);
    });

    test('should create NftModel from Nft entity', () {
      final nftModel = NftModel.fromEntity(testNft);

      expect(nftModel.id, testNft.id);
      expect(nftModel.name, testNft.name);
      expect(nftModel.description, testNft.description);
      expect(nftModel.imageUrl, testNft.imageUrl);
      expect(nftModel.creator, testNft.creator);
      expect(nftModel.owner, testNft.owner);
      expect(nftModel.tokenId, testNft.tokenId);
      expect(nftModel.assetId, testNft.assetId);
      expect(nftModel.collection, testNft.collection);
      expect(nftModel.mintPrice, testNft.mintPrice);
      expect(nftModel.mintDate, testNft.mintDate);
      expect(nftModel.attributes, testNft.attributes);
      expect(nftModel.externalUrl, testNft.externalUrl);
      expect(nftModel.animationUrl, testNft.animationUrl);
      expect(nftModel.isScam, testNft.isScam);
      expect(nftModel.scamReason, testNft.scamReason);
      expect(nftModel.isHidden, testNft.isHidden);
    });

    test('should handle JSON with missing optional fields', () {
      const minimalJson = {
        'id': 'nft_3',
        'name': 'Minimal NFT',
        'description': 'Minimal test NFT',
        'image_url': 'https://example.com/image3.jpg',
        'creator': 'CREATOR_003',
        'owner': 'OWNER_003',
        'token_id': 3,
        'asset_id': 1000003,
        'collection': 'Test Collection',
        'mint_price': 3.0,
        'mint_date': '2023-01-01T00:00:00.000Z',
      };

      final nftModel = NftModel.fromJson(minimalJson);

      expect(nftModel.attributes, null);
      expect(nftModel.externalUrl, null);
      expect(nftModel.animationUrl, null);
      expect(nftModel.isScam, false); // Default value
      expect(nftModel.scamReason, null);
      expect(nftModel.isHidden, false); // Default value
    });
  });

  group('NftTransactionModel', () {
    const testJson = {
      'id': 'tx_1',
      'nft_id': 'nft_1',
      'from_address': 'FROM_ADDRESS',
      'to_address': 'TO_ADDRESS',
      'amount': 1,
      'timestamp': '2023-01-01T12:00:00.000Z',
      'note': 'Test transaction',
      'fee': 0.001,
      'status': 'completed',
    };

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

    test('should create NftTransactionModel from JSON', () {
      final transactionModel = NftTransactionModel.fromJson(testJson);

      expect(transactionModel.id, 'tx_1');
      expect(transactionModel.nftId, 'nft_1');
      expect(transactionModel.fromAddress, 'FROM_ADDRESS');
      expect(transactionModel.toAddress, 'TO_ADDRESS');
      expect(transactionModel.amount, 1);
      expect(transactionModel.timestamp, DateTime.parse('2023-01-01T12:00:00.000Z'));
      expect(transactionModel.note, 'Test transaction');
      expect(transactionModel.fee, 0.001);
      expect(transactionModel.status, NftTransactionStatus.completed);
    });

    test('should convert NftTransactionModel to JSON', () {
      final transactionModel = NftTransactionModel.fromJson(testJson);
      final json = transactionModel.toJson();

      expect(json['id'], 'tx_1');
      expect(json['nft_id'], 'nft_1');
      expect(json['from_address'], 'FROM_ADDRESS');
      expect(json['to_address'], 'TO_ADDRESS');
      expect(json['amount'], 1);
      expect(json['timestamp'], '2023-01-01T12:00:00.000Z');
      expect(json['note'], 'Test transaction');
      expect(json['fee'], 0.001);
      expect(json['status'], 'completed');
    });

    test('should create NftTransactionModel from NftTransaction entity', () {
      final transactionModel = NftTransactionModel.fromEntity(testTransaction);

      expect(transactionModel.id, testTransaction.id);
      expect(transactionModel.nftId, testTransaction.nftId);
      expect(transactionModel.fromAddress, testTransaction.fromAddress);
      expect(transactionModel.toAddress, testTransaction.toAddress);
      expect(transactionModel.amount, testTransaction.amount);
      expect(transactionModel.timestamp, testTransaction.timestamp);
      expect(transactionModel.note, testTransaction.note);
      expect(transactionModel.fee, testTransaction.fee);
      expect(transactionModel.status, testTransaction.status);
    });

    test('should handle unknown status with default', () {
      const jsonWithUnknownStatus = {
        'id': 'tx_2',
        'nft_id': 'nft_2',
        'from_address': 'FROM_ADDRESS_2',
        'to_address': 'TO_ADDRESS_2',
        'amount': 1,
        'timestamp': '2023-01-01T12:00:00.000Z',
        'status': 'unknown_status',
      };

      final transactionModel = NftTransactionModel.fromJson(jsonWithUnknownStatus);

      expect(transactionModel.status, NftTransactionStatus.pending); // Default value
    });
  });
}
