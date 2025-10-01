import '../../domain/entities/news_article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart' as failures;
import '../models/news_article_model.dart';

/// Implementation of NewsRepository
class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl();

  @override
  Future<Result<List<NewsArticle>>> getAllNews() async {
    try {
      // TODO: Implement actual data source calls
      // For now, return mock news articles
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockNews = _generateMockNews();
      return Result.success(mockNews);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> getLatestNews({int limit = 20}) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      // Sort by published date (newest first)
      allNews.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      final latestNews = allNews.take(limit).toList();

      return Result.success(latestNews);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> getTrendingNews({int limit = 10}) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      // Filter trending news (recent and has trending tags)
      final trendingNews = allNews
          .where((article) => article.isTrending)
          .toList();
      // Sort by published date (newest first)
      trendingNews.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      final topTrending = trendingNews.take(limit).toList();

      return Result.success(topTrending);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> getNewsByCategory(
    NewsCategory category, {
    int limit = 20,
  }) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      final filteredNews = allNews
          .where((article) => article.category == category)
          .toList();
      // Sort by published date (newest first)
      filteredNews.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      final categoryNews = filteredNews.take(limit).toList();

      return Result.success(categoryNews);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> getBreakingNews({int limit = 5}) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      // Filter breaking news (very recent)
      final breakingNews = allNews
          .where((article) => article.isBreakingNews)
          .toList();
      // Sort by published date (newest first)
      breakingNews.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      final topBreaking = breakingNews.take(limit).toList();

      return Result.success(topBreaking);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<NewsArticle>> getNewsById(String id) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      final article = allNews.firstWhere(
        (article) => article.id == id,
        orElse: () => throw Exception('News article not found'),
      );

      return Result.success(article);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> searchNews(
    String query, {
    int limit = 20,
  }) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      final lowercaseQuery = query.toLowerCase();
      final searchResults = allNews.where((article) {
        return article.title.toLowerCase().contains(lowercaseQuery) ||
            article.content.toLowerCase().contains(lowercaseQuery) ||
            article.summary.toLowerCase().contains(lowercaseQuery) ||
            article.tags.any(
              (tag) => tag.toLowerCase().contains(lowercaseQuery),
            );
      }).toList();

      // Sort by published date (newest first)
      searchResults.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      final limitedResults = searchResults.take(limit).toList();

      return Result.success(limitedResults);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> getBookmarkedNews() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allNews = _generateMockNews();
      final bookmarkedNews = allNews
          .where((article) => article.isBookmarked == true)
          .toList();
      // Sort by published date (newest first)
      bookmarkedNews.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      return Result.success(bookmarkedNews);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> bookmarkNews(String id) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Simulate network delay

      // TODO: Implement actual bookmarking logic
      return Result.success(null);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> removeBookmark(String id) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Simulate network delay

      // TODO: Implement actual bookmark removal logic
      return Result.success(null);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String id) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 300),
      ); // Simulate network delay

      // TODO: Implement actual mark as read logic
      return Result.success(null);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<NewsArticle>>> refreshNews() async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockNews = _generateMockNews();
      return Result.success(mockNews);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  /// Generates mock news data
  List<NewsArticle> _generateMockNews() {
    final now = DateTime.now();
    return [
      NewsArticleModel(
        id: 'algorand-governance-update',
        title:
            'Algorand Governance Period 8 Results: Record Participation and New Proposals',
        content:
            'The Algorand Foundation has announced the results of Governance Period 8, which saw record participation from the community. Over 2.5 billion ALGO tokens were committed to governance, representing a significant increase from previous periods. The community voted on several key proposals including ecosystem development funding, technical improvements, and governance structure enhancements. The results show strong support for continued ecosystem growth and innovation on the Algorand blockchain.',
        summary:
            'Governance Period 8 achieved record participation with 2.5B ALGO committed, voting on ecosystem funding and technical improvements.',
        author: 'Algorand Foundation',
        source: 'Algorand Official',
        url: 'https://algorand.foundation/news/governance-period-8-results',
        imageUrl: 'https://algorand.foundation/images/governance-update.jpg',
        publishedAt: now.subtract(const Duration(hours: 2)),
        category: NewsCategory.governance,
        tags: const ['algorand', 'governance', 'voting', 'ecosystem'],
        readTime: 5,
        isBookmarked: false,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'yieldly-new-features',
        title:
            'Yieldly Launches New Staking Pools and Cross-Chain Bridge Integration',
        content:
            'Yieldly Finance has announced the launch of several new staking pools and the integration of a cross-chain bridge feature. The new pools include opportunities for staking various Algorand Standard Assets (ASAs) with competitive APY rates. The cross-chain bridge integration will allow users to move assets between Algorand and other supported blockchains, expanding the platform\'s utility and accessibility. This development represents a significant step forward in Yieldly\'s mission to provide comprehensive DeFi services on Algorand.',
        summary:
            'Yieldly introduces new staking pools and cross-chain bridge integration, expanding DeFi opportunities on Algorand.',
        author: 'Yieldly Team',
        source: 'Yieldly Finance',
        url: 'https://yieldly.finance/news/new-features-launch',
        imageUrl: 'https://yieldly.finance/images/new-features.jpg',
        publishedAt: now.subtract(const Duration(hours: 4)),
        category: NewsCategory.defi,
        tags: const ['yieldly', 'defi', 'staking', 'cross-chain', 'bridge'],
        readTime: 4,
        isBookmarked: true,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'tinyman-v2-update',
        title:
            'Tinyman V2 Protocol Upgrade Brings Enhanced Security and Performance',
        content:
            'Tinyman has successfully deployed its V2 protocol upgrade, introducing enhanced security measures and improved performance. The upgrade includes better smart contract architecture, reduced gas fees, and improved user experience. The new version also introduces advanced trading features and better liquidity management tools. The Tinyman team has conducted extensive testing and security audits to ensure the reliability of the new protocol.',
        summary:
            'Tinyman V2 protocol upgrade enhances security, performance, and introduces advanced trading features.',
        author: 'Tinyman Team',
        source: 'Tinyman',
        url: 'https://tinyman.org/news/v2-upgrade',
        imageUrl: 'https://tinyman.org/images/v2-upgrade.jpg',
        publishedAt: now.subtract(const Duration(hours: 6)),
        category: NewsCategory.technology,
        tags: const ['tinyman', 'dex', 'upgrade', 'security', 'performance'],
        readTime: 6,
        isBookmarked: false,
        isRead: true,
      ),
      NewsArticleModel(
        id: 'opulous-music-nft-drop',
        title: 'Opulous Announces Major Music NFT Drop Featuring Top Artists',
        content:
            'Opulous has announced an upcoming major music NFT drop featuring collaborations with several top artists. The drop will include exclusive tracks, album artwork, and unique digital collectibles. This represents one of the largest music NFT initiatives on the Algorand blockchain, showcasing the platform\'s capabilities in the music industry. The drop is scheduled for next month and will be available through the Opulous marketplace.',
        summary:
            'Opulous announces major music NFT drop with top artists, showcasing Algorand\'s music industry capabilities.',
        author: 'Opulous Team',
        source: 'Opulous',
        url: 'https://opulous.org/news/music-nft-drop',
        imageUrl: 'https://opulous.org/images/music-nft-drop.jpg',
        publishedAt: now.subtract(const Duration(hours: 8)),
        category: NewsCategory.nft,
        tags: const ['opulous', 'nft', 'music', 'artists', 'marketplace'],
        readTime: 3,
        isBookmarked: false,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'algorand-partnership-microsoft',
        title:
            'Algorand Partners with Microsoft for Enterprise Blockchain Solutions',
        content:
            'Algorand has announced a strategic partnership with Microsoft to develop enterprise blockchain solutions. The collaboration will focus on creating scalable, secure, and efficient blockchain infrastructure for enterprise clients. This partnership represents a significant milestone in Algorand\'s enterprise adoption strategy and will help accelerate the development of blockchain-based business solutions.',
        summary:
            'Algorand partners with Microsoft to develop enterprise blockchain solutions, accelerating enterprise adoption.',
        author: 'Algorand Foundation',
        source: 'Algorand Official',
        url: 'https://algorand.foundation/news/microsoft-partnership',
        imageUrl:
            'https://algorand.foundation/images/microsoft-partnership.jpg',
        publishedAt: now.subtract(const Duration(hours: 12)),
        category: NewsCategory.partnerships,
        tags: const [
          'algorand',
          'microsoft',
          'partnership',
          'enterprise',
          'blockchain',
        ],
        readTime: 7,
        isBookmarked: true,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'algo-price-analysis',
        title:
            'ALGO Price Analysis: Technical Indicators Show Bullish Momentum',
        content:
            'Technical analysis of ALGO price movements shows strong bullish momentum with key resistance levels being tested. The cryptocurrency has shown resilience in recent market conditions, with increased trading volume and positive sentiment from the community. Analysts suggest that the upcoming governance rewards and ecosystem developments could provide further support for price appreciation.',
        summary:
            'ALGO shows bullish momentum with strong technical indicators and positive ecosystem developments.',
        author: 'Crypto Analyst',
        source: 'Crypto News',
        url: 'https://cryptonews.com/algo-price-analysis',
        imageUrl: 'https://cryptonews.com/images/algo-analysis.jpg',
        publishedAt: now.subtract(const Duration(hours: 16)),
        category: NewsCategory.market,
        tags: const ['algo', 'price', 'analysis', 'bullish', 'trading'],
        readTime: 4,
        isBookmarked: false,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'algorand-carbon-negative',
        title:
            'Algorand Achieves Carbon Negative Status Through Green Blockchain Initiative',
        content:
            'Algorand has officially achieved carbon negative status through its comprehensive green blockchain initiative. The platform has implemented various sustainability measures including carbon offset programs, renewable energy usage, and efficient consensus mechanisms. This achievement positions Algorand as a leader in sustainable blockchain technology and aligns with global environmental goals.',
        summary:
            'Algorand achieves carbon negative status through green blockchain initiatives and sustainability measures.',
        author: 'Environmental Team',
        source: 'Algorand Official',
        url: 'https://algorand.foundation/news/carbon-negative',
        imageUrl: 'https://algorand.foundation/images/carbon-negative.jpg',
        publishedAt: now.subtract(const Duration(hours: 20)),
        category: NewsCategory.technology,
        tags: const [
          'algorand',
          'sustainability',
          'carbon-negative',
          'green',
          'environment',
        ],
        readTime: 5,
        isBookmarked: false,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'defi-ecosystem-growth',
        title:
            'Algorand DeFi Ecosystem Shows 300% Growth in TVL Over Past Quarter',
        content:
            'The Algorand DeFi ecosystem has demonstrated remarkable growth with Total Value Locked (TVL) increasing by 300% over the past quarter. This growth is driven by the launch of new protocols, increased user adoption, and improved infrastructure. Key contributors include Yieldly, Tinyman, Folks Finance, and Algofi, which have all seen significant increases in user activity and asset deposits.',
        summary:
            'Algorand DeFi ecosystem TVL grows 300% in Q3, driven by new protocols and increased user adoption.',
        author: 'DeFi Analyst',
        source: 'DeFi Pulse',
        url: 'https://defipulse.com/algorand-ecosystem-growth',
        imageUrl: 'https://defipulse.com/images/algorand-growth.jpg',
        publishedAt: now.subtract(const Duration(hours: 24)),
        category: NewsCategory.defi,
        tags: const ['defi', 'tvl', 'growth', 'ecosystem', 'algorand'],
        readTime: 6,
        isBookmarked: true,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'regulatory-clarity-algorand',
        title:
            'Regulatory Clarity for Algorand: SEC Provides Guidance on Token Classification',
        content:
            'The SEC has provided new guidance on token classification that offers clarity for Algorand and other blockchain projects. The guidance clarifies the regulatory framework for utility tokens and provides a clearer path for compliance. This development is expected to reduce regulatory uncertainty and encourage further institutional adoption of Algorand-based solutions.',
        summary:
            'SEC provides regulatory clarity for Algorand tokens, reducing uncertainty and encouraging institutional adoption.',
        author: 'Legal Team',
        source: 'Blockchain Legal',
        url: 'https://blockchainlegal.com/sec-guidance-algorand',
        imageUrl: 'https://blockchainlegal.com/images/sec-guidance.jpg',
        publishedAt: now.subtract(const Duration(days: 1)),
        category: NewsCategory.regulation,
        tags: const ['sec', 'regulation', 'compliance', 'tokens', 'guidance'],
        readTime: 8,
        isBookmarked: false,
        isRead: false,
      ),
      NewsArticleModel(
        id: 'algorand-developer-grants',
        title: 'Algorand Foundation Announces \$50M Developer Grant Program',
        content:
            'The Algorand Foundation has announced a \$50 million developer grant program to support innovation and development on the Algorand blockchain. The program will provide funding for projects across various categories including DeFi, NFTs, infrastructure, and developer tools. This initiative aims to accelerate ecosystem growth and attract top talent to build on Algorand.',
        summary:
            'Algorand Foundation launches \$50M developer grant program to support innovation and ecosystem growth.',
        author: 'Algorand Foundation',
        source: 'Algorand Official',
        url: 'https://algorand.foundation/news/developer-grants',
        imageUrl: 'https://algorand.foundation/images/developer-grants.jpg',
        publishedAt: now.subtract(const Duration(days: 2)),
        category: NewsCategory.ecosystem,
        tags: const [
          'grants',
          'developers',
          'funding',
          'ecosystem',
          'innovation',
        ],
        readTime: 4,
        isBookmarked: false,
        isRead: false,
      ),
    ];
  }
}
