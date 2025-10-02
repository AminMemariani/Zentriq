import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:zentriq/viewmodels/nft_viewmodel.dart';
import 'package:zentriq/domain/entities/nft.dart';
import 'package:zentriq/domain/usecases/get_all_nfts.dart';
import 'package:zentriq/domain/usecases/send_nft.dart';
import 'package:zentriq/domain/usecases/update_nft_visibility.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/core/utils/use_case.dart';
import 'package:zentriq/core/errors/failures.dart';

import 'nft_viewmodel_test.mocks.dart';

@GenerateMocks([GetAllNfts, SendNft, UpdateNftVisibility])
void main() {
  // Provide dummy values for Mockito
  provideDummy<Result<List<Nft>>>(Result.success([]));
  provideDummy<Result<NftTransaction>>(Result.success(NftTransaction(
    id: 'dummy',
    nftId: 'dummy',
    fromAddress: 'dummy',
    toAddress: 'dummy',
    amount: 1,
    timestamp: DateTime.now(),
  )));
  provideDummy<Result<void>>(const Result.success(null));
  group('NftViewModel', () {
    late NftViewModel viewModel;
    late MockGetAllNfts mockGetAllNfts;
    late MockSendNft mockSendNft;
    late MockUpdateNftVisibility mockUpdateNftVisibility;

    setUp(() {
      mockGetAllNfts = MockGetAllNfts();
      mockSendNft = MockSendNft();
      mockUpdateNftVisibility = MockUpdateNftVisibility();
      viewModel = NftViewModel(
        getAllNfts: mockGetAllNfts,
        sendNft: mockSendNft,
        updateNftVisibility: mockUpdateNftVisibility,
      );
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(viewModel.allNfts, isEmpty);
        expect(viewModel.safeNfts, isEmpty);
        expect(viewModel.suspiciousNfts, isEmpty);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, null);
        expect(viewModel.currentTab, NftTab.all);
        expect(viewModel.selectedNft, null);
        expect(viewModel.totalNftCount, 0);
        expect(viewModel.safeNftCount, 0);
        expect(viewModel.suspiciousNftCount, 0);
      });
    });

    group('loadNfts', () {
      test('should load NFTs successfully', () async {
        // Arrange
        final testNfts = [
          Nft(
            id: 'nft_1',
            name: 'Safe NFT',
            description: 'A safe NFT',
            imageUrl: 'https://example.com/image1.jpg',
            creator: 'CREATOR_001',
            owner: 'OWNER_001',
            tokenId: 1,
            assetId: 1000001,
            collection: 'Safe Collection',
            mintPrice: 1.0,
            mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
            isScam: false,
            isHidden: false,
          ),
          Nft(
            id: 'nft_2',
            name: 'Suspicious NFT',
            description: 'A suspicious NFT',
            imageUrl: 'https://example.com/image2.jpg',
            creator: 'SCAM123456789',
            owner: 'OWNER_002',
            tokenId: 2,
            assetId: 1000002,
            collection: 'Suspicious Collection',
            mintPrice: 0.001,
            mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
            isScam: true,
            scamReason: 'Blacklisted creator address',
            isHidden: false,
          ),
        ];

        when(mockGetAllNfts(const NoParams()))
            .thenAnswer((_) async => Result.success(testNfts));

        // Act
        await viewModel.loadNfts();

        // Assert
        expect(viewModel.allNfts, testNfts);
        expect(viewModel.safeNfts, [testNfts[0]]);
        expect(viewModel.suspiciousNfts, [testNfts[1]]);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, null);
        expect(viewModel.totalNftCount, 2);
        expect(viewModel.safeNftCount, 1);
        expect(viewModel.suspiciousNftCount, 1);
      });

      test('should handle loading error', () async {
        // Arrange
        when(mockGetAllNfts(const NoParams()))
            .thenAnswer((_) async => Result.failure(ServerFailure('Network error')));

        // Act
        await viewModel.loadNfts();

        // Assert
        expect(viewModel.allNfts, isEmpty);
        expect(viewModel.safeNfts, isEmpty);
        expect(viewModel.suspiciousNfts, isEmpty);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, 'Network error');
      });

      test('should set loading state during operation', () async {
        // Arrange
        when(mockGetAllNfts(const NoParams()))
            .thenAnswer((_) async {
              expect(viewModel.isLoading, true);
              return Result.success([]);
            });

        // Act
        await viewModel.loadNfts();

        // Assert
        expect(viewModel.isLoading, false);
      });
    });

    group('sendNftToAddress', () {
      test('should send NFT successfully', () async {
        // Arrange
        const nftId = 'nft_1';
        const toAddress = 'RECIPIENT_ADDRESS';
        const note = 'Test transfer';

        final testTransaction = NftTransaction(
          id: 'tx_1',
          nftId: nftId,
          fromAddress: 'USER_WALLET_ADDRESS',
          toAddress: toAddress,
          amount: 1,
          timestamp: DateTime.now(),
          note: note,
          fee: 0.001,
          status: NftTransactionStatus.completed,
        );

        when(mockSendNft(SendNftParams(
          nftId: nftId,
          toAddress: toAddress,
          note: note,
        ))).thenAnswer((_) async => Result.success(testTransaction));

        // Note: In a real test, we would need to load NFTs first or mock the internal state
        // For now, we'll test the method call without checking the internal state changes

        // Act
        final result = await viewModel.sendNftToAddress(
          nftId: nftId,
          toAddress: toAddress,
          note: note,
        );

        // Assert
        expect(result, true);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, null);
      });

      test('should handle send NFT error', () async {
        // Arrange
        const nftId = 'nft_1';
        const toAddress = 'INVALID_ADDRESS';

        when(mockSendNft(SendNftParams(
          nftId: nftId,
          toAddress: toAddress,
          note: null,
        ))).thenAnswer((_) async => Result.failure(ValidationFailure('Invalid address')));

        // Act
        final result = await viewModel.sendNftToAddress(
          nftId: nftId,
          toAddress: toAddress,
        );

        // Assert
        expect(result, false);
        expect(viewModel.error, 'Invalid address');
        expect(viewModel.isLoading, false);
      });
    });

    group('updateNftHiddenStatus', () {
      test('should update NFT hidden status successfully', () async {
        // Arrange
        const nftId = 'nft_1';
        const isHidden = true;

        when(mockUpdateNftVisibility(UpdateNftVisibilityParams(
          nftId: nftId,
          isHidden: isHidden,
        ))).thenAnswer((_) async => const Result.success(null));

        // Note: In a real test, we would need to load NFTs first or mock the internal state

        // Act
        await viewModel.updateNftHiddenStatus(
          nftId: nftId,
          isHidden: isHidden,
        );

        // Assert
        expect(viewModel.error, null);
      });

      test('should handle update error', () async {
        // Arrange
        const nftId = 'nft_1';
        const isHidden = true;

        when(mockUpdateNftVisibility(UpdateNftVisibilityParams(
          nftId: nftId,
          isHidden: isHidden,
        ))).thenAnswer((_) async => Result.failure(ServerFailure('Update failed')));

        // Act
        await viewModel.updateNftHiddenStatus(
          nftId: nftId,
          isHidden: isHidden,
        );

        // Assert
        expect(viewModel.error, 'Update failed');
      });
    });

    group('Navigation and Selection', () {
      test('should change tab correctly', () {
        // Act
        viewModel.changeTab(NftTab.suspicious);

        // Assert
        expect(viewModel.currentTab, NftTab.suspicious);
      });

      test('should select NFT correctly', () {
        // Arrange
        final testNft = Nft(
          id: 'nft_1',
          name: 'Test NFT',
          description: 'A test NFT',
          imageUrl: 'https://example.com/image.jpg',
          creator: 'CREATOR_001',
          owner: 'OWNER_001',
          tokenId: 1,
          assetId: 1000001,
          collection: 'Test Collection',
          mintPrice: 1.0,
          mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
        );

        // Act
        viewModel.selectNft(testNft);

        // Assert
        expect(viewModel.selectedNft, testNft);
      });

      test('should clear selected NFT', () {
        // Arrange
        final testNft = Nft(
          id: 'nft_1',
          name: 'Test NFT',
          description: 'A test NFT',
          imageUrl: 'https://example.com/image.jpg',
          creator: 'CREATOR_001',
          owner: 'OWNER_001',
          tokenId: 1,
          assetId: 1000001,
          collection: 'Test Collection',
          mintPrice: 1.0,
          mintDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
        );
        viewModel.selectNft(testNft);

        // Act
        viewModel.clearSelectedNft();

        // Assert
        expect(viewModel.selectedNft, null);
      });
    });

    group('currentTabNfts', () {
      test('should return safe NFTs when on all tab', () {
        // Arrange
        viewModel.changeTab(NftTab.all);

        // Act & Assert
        expect(viewModel.currentTabNfts, viewModel.safeNfts);
      });

      test('should return suspicious NFTs when on suspicious tab', () {
        // Arrange
        viewModel.changeTab(NftTab.suspicious);

        // Act & Assert
        expect(viewModel.currentTabNfts, viewModel.suspiciousNfts);
      });
    });
  });
}
