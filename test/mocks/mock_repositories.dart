import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../lib/domain/repositories/wallet_repository.dart';
import '../../lib/domain/repositories/token_repository.dart';
import '../../lib/domain/repositories/project_repository.dart';
import '../../lib/domain/repositories/news_repository.dart';
import '../../lib/domain/usecases/get_wallet.dart';
import '../../lib/domain/usecases/get_transaction_history.dart';
import '../../lib/domain/usecases/send_transaction.dart';
import '../../lib/domain/usecases/get_all_tokens.dart';
import '../../lib/domain/usecases/get_top_performers.dart';
import '../../lib/domain/usecases/get_all_projects.dart';
import '../../lib/domain/usecases/get_featured_projects.dart';
import '../../lib/domain/usecases/get_latest_news.dart';
import '../../lib/domain/usecases/get_trending_news.dart';
import '../../lib/domain/entities/wallet.dart';
import '../../lib/domain/entities/token.dart';
import '../../lib/domain/entities/project.dart';
import '../../lib/domain/entities/news_article.dart';
import '../../lib/domain/entities/transaction.dart';
import '../../lib/core/utils/result.dart';
import '../../lib/core/errors/failures.dart';

// Generate mocks for all repositories and use cases
@GenerateMocks([
  WalletRepository,
  TokenRepository,
  ProjectRepository,
  NewsRepository,
  GetWallet,
  GetTransactionHistory,
  SendTransaction,
  GetAllTokens,
  GetTopPerformers,
  GetAllProjects,
  GetFeaturedProjects,
  GetLatestNews,
  GetTrendingNews,
])
void main() {}

// Mock data generators
class MockData {
  static Wallet createMockWallet() {
    return Wallet(
      address:
          'ALGORAND123456789012345678901234567890123456789012345678901234567890',
      balance: 1.0, // 1 ALGO
      balanceInUSD: 0.25,
      name: 'Test Wallet',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  static List<Token> createMockTokens() {
    return [
      Token(
        id: 'algorand',
        name: 'Algorand',
        symbol: 'ALGO',
        price: 0.25,
        priceChange24h: 0.012,
        priceChangePercentage24h: 5.2,
        marketCap: 2000000000.0,
        volume24h: 50000000.0,
        circulatingSupply: 8000000000.0,
        totalSupply: 10000000000.0,
        logoUrl: 'https://example.com/algo.png',
        lastUpdated: DateTime.now(),
      ),
      Token(
        id: 'yieldly',
        name: 'Yieldly',
        symbol: 'YLDY',
        price: 0.001,
        priceChange24h: -0.000021,
        priceChangePercentage24h: -2.1,
        marketCap: 10000000.0,
        volume24h: 1000000.0,
        circulatingSupply: 10000000000.0,
        totalSupply: 10000000000.0,
        logoUrl: 'https://example.com/yldy.png',
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  static List<Project> createMockProjects() {
    return [
      Project(
        id: 'yieldly',
        name: 'Yieldly',
        description: 'No-loss lottery and DeFi platform for Algorand ecosystem',
        shortDescription: 'DeFi platform',
        logoUrl: 'https://example.com/yieldly.png',
        category: ProjectCategory.defi,
        website: 'https://yieldly.finance',
        isVerified: true,
        totalValueLocked: 15000000.0,
        activeUsers: 25000,
        launchDate: DateTime(2021, 6, 1),
        socialLinks: {'twitter': 'https://twitter.com/YieldlyFinance'},
        tokenSymbol: 'YLDY',
        tokenPrice: 0.001,
        marketCap: 10000000.0,
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  static List<NewsArticle> createMockNewsArticles() {
    return [
      NewsArticle(
        id: 'news1',
        title: 'Algorand Governance Period 8 Results',
        content: 'The results are in for Governance Period 8...',
        summary: 'Governance Period 8 concludes successfully',
        author: 'Algorand Foundation',
        source: 'Algorand Official',
        url: 'https://algorand.foundation/news',
        imageUrl: 'https://example.com/news1.jpg',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: NewsCategory.governance,
        tags: ['algorand', 'governance'],
        readTime: 5,
      ),
    ];
  }
}

// Provide dummy values for Result types
void provideDummy<T>(T dummyValue) {
  // This is handled by mockito automatically
}

// Provide dummy values for all Result types used in tests
void provideDummyValues() {
  provideDummy<Result<Wallet>>(Result.success(Wallet(
    address: 'dummy',
    balance: 0.0,
    balanceInUSD: 0.0,
    name: 'Dummy Wallet',
  )));
  
  provideDummy<Result<List<Transaction>>>(Result.success([]));
  
  provideDummy<Result<Transaction>>(Result.success(Transaction(
    id: 'dummy',
    type: TransactionType.send,
    amount: 0.0,
    fromAddress: 'dummy',
    toAddress: 'dummy',
    timestamp: DateTime.now(),
    status: TransactionStatus.completed,
  )));
  
  provideDummy<Result<List<Token>>>(Result.success([]));
  
  provideDummy<Result<List<Project>>>(Result.success([]));
  
  provideDummy<Result<List<NewsArticle>>>(Result.success([]));
  
  provideDummy<Result<String>>(Result.success('dummy'));
  
  // Provide dummy failure results
  provideDummy<Result<Wallet>>(Result.failure(ServerFailure('dummy')));
  provideDummy<Result<List<Transaction>>>(Result.failure(NetworkFailure('dummy')));
  provideDummy<Result<Transaction>>(Result.failure(ValidationFailure('dummy')));
  provideDummy<Result<List<Token>>>(Result.failure(ServerFailure('dummy')));
  provideDummy<Result<List<Project>>>(Result.failure(NetworkFailure('dummy')));
  provideDummy<Result<List<NewsArticle>>>(Result.failure(ServerFailure('dummy')));
  provideDummy<Result<String>>(Result.failure(ValidationFailure('dummy')));
}
