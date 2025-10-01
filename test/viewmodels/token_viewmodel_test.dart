import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zentriq/core/errors/failures.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/domain/entities/token.dart';
import 'package:zentriq/viewmodels/token_viewmodel.dart';

import '../mocks/mock_repositories.mocks.dart';

void main() {
  group('TokenViewModel', () {
    late TokenViewModel viewModel;
    late MockGetAllTokens mockGetAllTokens;
    late MockGetTopPerformers mockGetTopPerformers;

    setUp(() {
      mockGetAllTokens = MockGetAllTokens();
      mockGetTopPerformers = MockGetTopPerformers();
      viewModel = TokenViewModel(mockGetAllTokens, mockGetTopPerformers);
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(viewModel.allTokens, isEmpty);
        expect(viewModel.topPerformers, isEmpty);
        expect(viewModel.isLoadingAllTokens, isFalse);
        expect(viewModel.isLoadingTopPerformers, isFalse);
        expect(viewModel.allTokensErrorMessage, isNull);
        expect(viewModel.topPerformersErrorMessage, isNull);
      });
    });

    group('Load All Tokens', () {
      test('should load all tokens successfully', () async {
        // Arrange
        final tTokens = [
          Token(
            id: 'algo',
            name: 'Algorand',
            symbol: 'ALGO',
            price: 0.25,
            priceChange24h: 0.01,
            priceChangePercentage24h: 5.0,
            marketCap: 2000000000,
            volume24h: 50000000,
          ),
        ];
        
        provideDummy<Result<List<Token>>>(Result.success(tTokens));
        when(mockGetAllTokens.call())
            .thenAnswer((_) async => Result.success(tTokens));

        // Act
        await viewModel.loadAllTokens();

        // Assert
        expect(viewModel.allTokens, tTokens);
        expect(viewModel.isLoadingAllTokens, false);
        expect(viewModel.allTokensErrorMessage, isNull);
        verify(mockGetAllTokens.call()).called(1);
      });

      test('should handle all tokens loading error', () async {
        // Arrange
        final failure = ServerFailure('error');
        provideDummy<Result<List<Token>>>(Result.failure(failure));
        when(mockGetAllTokens.call())
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadAllTokens();

        // Assert
        expect(viewModel.allTokens, isEmpty);
        expect(viewModel.isLoadingAllTokens, false);
        expect(viewModel.allTokensErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetAllTokens.call()).called(1);
      });
    });

    group('Load Top Performers', () {
      test('should load top performers successfully', () async {
        // Arrange
        final tTokens = [
          Token(
            id: 'algo',
            name: 'Algorand',
            symbol: 'ALGO',
            price: 0.25,
            priceChange24h: 0.01,
            priceChangePercentage24h: 5.0,
            marketCap: 2000000000,
            volume24h: 50000000,
          ),
        ];
        
        provideDummy<Result<List<Token>>>(Result.success(tTokens));
        when(mockGetTopPerformers.call(any))
            .thenAnswer((_) async => Result.success(tTokens));

        // Act
        await viewModel.loadTopPerformers();

        // Assert
        expect(viewModel.topPerformers, tTokens);
        expect(viewModel.isLoadingTopPerformers, false);
        expect(viewModel.topPerformersErrorMessage, isNull);
        verify(mockGetTopPerformers.call(any)).called(1);
      });

      test('should handle top performers loading error', () async {
        // Arrange
        final failure = NetworkFailure('error');
        provideDummy<Result<List<Token>>>(Result.failure(failure));
        when(mockGetTopPerformers.call(any))
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadTopPerformers();

        // Assert
        expect(viewModel.topPerformers, isEmpty);
        expect(viewModel.isLoadingTopPerformers, false);
        expect(viewModel.topPerformersErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetTopPerformers.call(any)).called(1);
      });
    });

    group('Search Tokens', () {
      test('should search tokens by query', () async {
        // Arrange
        final tTokens = [
          Token(
            id: 'algo',
            name: 'Algorand',
            symbol: 'ALGO',
            price: 0.25,
            priceChange24h: 0.01,
            priceChangePercentage24h: 5.0,
            marketCap: 2000000000,
            volume24h: 50000000,
          ),
          Token(
            id: 'usdc',
            name: 'USD Coin',
            symbol: 'USDC',
            price: 1.0,
            priceChange24h: 0.001,
            priceChangePercentage24h: 0.1,
            marketCap: 30000000000,
            volume24h: 1000000000,
          ),
        ];
        
        provideDummy<Result<List<Token>>>(Result.success(tTokens));
        when(mockGetAllTokens.call())
            .thenAnswer((_) async => Result.success(tTokens));
        await viewModel.loadAllTokens();

        // Act & Assert
        expect(viewModel.searchTokens('algo'), [tTokens[0]]);
        expect(viewModel.searchTokens('usd'), [tTokens[1]]);
        expect(viewModel.searchTokens(''), tTokens);
      });
    });

    group('Get Tokens By Price Change', () {
      test('should sort tokens by price change', () async {
        // Arrange
        final tTokens = [
          Token(
            id: 'algo',
            name: 'Algorand',
            symbol: 'ALGO',
            price: 0.25,
            priceChange24h: 0.01,
            priceChangePercentage24h: 5.0,
            marketCap: 2000000000,
            volume24h: 50000000,
          ),
          Token(
            id: 'usdc',
            name: 'USD Coin',
            symbol: 'USDC',
            price: 1.0,
            priceChange24h: 0.001,
            priceChangePercentage24h: 0.1,
            marketCap: 30000000000,
            volume24h: 1000000000,
          ),
        ];
        
        provideDummy<Result<List<Token>>>(Result.success(tTokens));
        when(mockGetAllTokens.call())
            .thenAnswer((_) async => Result.success(tTokens));
        await viewModel.loadAllTokens();

        // Act
        final sortedTokens = viewModel.getTokensByPriceChange();

        // Assert
        expect(sortedTokens, [tTokens[0], tTokens[1]]); // 5.0, 0.1
      });
    });

    group('Refresh Tokens', () {
      test('should refresh both all tokens and top performers', () async {
        // Arrange
        final tTokens = [
          Token(
            id: 'algo',
            name: 'Algorand',
            symbol: 'ALGO',
            price: 0.25,
            priceChange24h: 0.01,
            priceChangePercentage24h: 5.0,
            marketCap: 2000000000,
            volume24h: 50000000,
          ),
        ];
        
        provideDummy<Result<List<Token>>>(Result.success(tTokens));
        when(mockGetAllTokens.call())
            .thenAnswer((_) async => Result.success(tTokens));
        when(mockGetTopPerformers.call(any))
            .thenAnswer((_) async => Result.success(tTokens));

        // Act
        await viewModel.refreshTokens();

        // Assert
        verify(mockGetAllTokens.call()).called(1);
        verify(mockGetTopPerformers.call(any)).called(1);
      });
    });
  });
}
