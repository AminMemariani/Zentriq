import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../../core/utils/result.dart';
import '../../core/errors/failures.dart' as failures;
import '../models/project_model.dart';

/// Implementation of ProjectRepository
class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl();

  @override
  Future<Result<List<Project>>> getAllProjects() async {
    try {
      // TODO: Implement actual data source calls
      // For now, return mock projects
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockProjects = _generateMockProjects();
      return Result.success(mockProjects);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Project>>> getProjectsByCategory(
    ProjectCategory category,
  ) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allProjects = _generateMockProjects();
      final filteredProjects = allProjects
          .where((project) => project.category == category)
          .toList();

      return Result.success(filteredProjects);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Project>>> getFeaturedProjects({int limit = 10}) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allProjects = _generateMockProjects();
      // Sort by TVL and active users, then take featured ones
      allProjects.sort((a, b) {
        final aScore = a.totalValueLocked + (a.activeUsers * 100);
        final bScore = b.totalValueLocked + (b.activeUsers * 100);
        return bScore.compareTo(aScore);
      });
      final featuredProjects = allProjects.take(limit).toList();

      return Result.success(featuredProjects);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Project>>> getRecentlyLaunchedProjects({
    int limit = 10,
  }) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allProjects = _generateMockProjects();
      // Sort by launch date (newest first)
      allProjects.sort((a, b) => b.launchDate.compareTo(a.launchDate));
      final recentProjects = allProjects.take(limit).toList();

      return Result.success(recentProjects);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Project>>> getPopularProjects({int limit = 10}) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 800),
      ); // Simulate network delay

      final allProjects = _generateMockProjects();
      // Filter popular projects (high TVL or active users)
      final popularProjects = allProjects
          .where((project) => project.isPopular)
          .toList();
      // Sort by popularity score
      popularProjects.sort((a, b) {
        final aScore = a.totalValueLocked + (a.activeUsers * 100);
        final bScore = b.totalValueLocked + (b.activeUsers * 100);
        return bScore.compareTo(aScore);
      });
      final topPopular = popularProjects.take(limit).toList();

      return Result.success(topPopular);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Project>> getProjectById(String id) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allProjects = _generateMockProjects();
      final project = allProjects.firstWhere(
        (project) => project.id == id,
        orElse: () => throw Exception('Project not found'),
      );

      return Result.success(project);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Project>>> searchProjects(String query) async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      final allProjects = _generateMockProjects();
      final lowercaseQuery = query.toLowerCase();
      final searchResults = allProjects.where((project) {
        return project.name.toLowerCase().contains(lowercaseQuery) ||
            project.description.toLowerCase().contains(lowercaseQuery) ||
            project.shortDescription.toLowerCase().contains(lowercaseQuery);
      }).toList();

      return Result.success(searchResults);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Project>>> refreshProjects() async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final mockProjects = _generateMockProjects();
      return Result.success(mockProjects);
    } catch (e) {
      return Result.failure(failures.ServerFailure(e.toString()));
    }
  }

  /// Generates mock project data
  List<Project> _generateMockProjects() {
    final now = DateTime.now();
    return [
      ProjectModel(
        id: 'yieldly',
        name: 'Yieldly',
        description:
            'Yieldly is a no-loss lottery and staking platform built on Algorand. Users can stake their ALGO tokens to participate in various lotteries and earn rewards without risking their principal.',
        shortDescription: 'No-loss lottery and staking platform',
        category: ProjectCategory.defi,
        website: 'https://yieldly.finance',
        logoUrl: 'https://yieldly.finance/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 3, 15),
        totalValueLocked: 25000000,
        activeUsers: 15000,
        socialLinks: {
          'twitter': 'https://twitter.com/yieldlyfinance',
          'discord': 'https://discord.gg/yieldly',
        },
        tokenSymbol: 'YLDY',
        tokenPrice: 0.0021,
        marketCap: 21000000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'tinyman',
        name: 'Tinyman',
        description:
            'Tinyman is a decentralized exchange (DEX) built on Algorand. It enables users to swap tokens, provide liquidity, and earn rewards through automated market making.',
        shortDescription: 'Decentralized exchange for Algorand',
        category: ProjectCategory.defi,
        website: 'https://tinyman.org',
        logoUrl: 'https://tinyman.org/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 10, 1),
        totalValueLocked: 45000000,
        activeUsers: 25000,
        socialLinks: {
          'twitter': 'https://twitter.com/tinymanorg',
          'telegram': 'https://t.me/tinyman',
        },
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'opulous',
        name: 'Opulous',
        description:
            'Opulous is a music NFT platform that allows artists to tokenize their music and fans to invest in their favorite artists. Built on Algorand for fast and low-cost transactions.',
        shortDescription: 'Music NFT platform for artists and fans',
        category: ProjectCategory.nft,
        website: 'https://opulous.org',
        logoUrl: 'https://opulous.org/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 6, 1),
        totalValueLocked: 8500000,
        activeUsers: 8000,
        socialLinks: {
          'twitter': 'https://twitter.com/opulous',
          'instagram': 'https://instagram.com/opulous',
        },
        tokenSymbol: 'OPUL',
        tokenPrice: 0.0845,
        marketCap: 84500000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'smile-coin',
        name: 'Smile Coin',
        description:
            'Smile Coin is a gaming platform that rewards players with cryptocurrency for playing games. It integrates with various gaming platforms and provides a seamless gaming experience.',
        shortDescription: 'Gaming platform with crypto rewards',
        category: ProjectCategory.gaming,
        website: 'https://smilecoin.us',
        logoUrl: 'https://smilecoin.us/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 4, 1),
        totalValueLocked: 3200000,
        activeUsers: 12000,
        socialLinks: {
          'twitter': 'https://twitter.com/smilecoin',
          'discord': 'https://discord.gg/smilecoin',
        },
        tokenSymbol: 'SMILE',
        tokenPrice: 0.0008,
        marketCap: 8000000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'planet-watch',
        name: 'Planet Watch',
        description:
            'Planet Watch is an environmental data network that rewards users for sharing air quality data. It uses Algorand blockchain to ensure data integrity and reward distribution.',
        shortDescription: 'Environmental data network with rewards',
        category: ProjectCategory.infrastructure,
        website: 'https://planetwatch.io',
        logoUrl: 'https://planetwatch.io/logo.png',
        isVerified: true,
        launchDate: DateTime(2020, 12, 1),
        totalValueLocked: 1200000,
        activeUsers: 5000,
        socialLinks: {
          'twitter': 'https://twitter.com/planetwatch',
          'linkedin': 'https://linkedin.com/company/planetwatch',
        },
        tokenSymbol: 'PLANETS',
        tokenPrice: 0.0012,
        marketCap: 12000000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'akita-inu',
        name: 'Akita Inu',
        description:
            'Akita Inu is a community-driven meme token on Algorand. It has gained popularity as a fun and engaging way to participate in the Algorand ecosystem.',
        shortDescription: 'Community-driven meme token',
        category: ProjectCategory.social,
        website: 'https://akita-inu.io',
        logoUrl: 'https://akita-inu.io/logo.png',
        isVerified: false,
        launchDate: DateTime(2021, 8, 1),
        totalValueLocked: 800000,
        activeUsers: 15000,
        socialLinks: {
          'twitter': 'https://twitter.com/akita_inu',
          'reddit': 'https://reddit.com/r/akita_inu',
        },
        tokenSymbol: 'AKITA',
        tokenPrice: 0.0000008,
        marketCap: 8000000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'choice-coin',
        name: 'Choice Coin',
        description:
            'Choice Coin is a governance token that enables decentralized decision-making. It allows communities to vote on important decisions and participate in governance.',
        shortDescription: 'Governance token for decentralized decisions',
        category: ProjectCategory.governance,
        website: 'https://choice-coin.com',
        logoUrl: 'https://choice-coin.com/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 5, 1),
        totalValueLocked: 500000,
        activeUsers: 3000,
        socialLinks: {
          'twitter': 'https://twitter.com/choice_coin',
          'github': 'https://github.com/choice-coin',
        },
        tokenSymbol: 'CHOICE',
        tokenPrice: 0.0003,
        marketCap: 3000000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'headline',
        name: 'Headline',
        description:
            'Headline is a decentralized news platform that rewards content creators and readers. It uses Algorand blockchain to ensure content authenticity and fair reward distribution.',
        shortDescription: 'Decentralized news platform with rewards',
        category: ProjectCategory.social,
        website: 'https://headline.dev',
        logoUrl: 'https://headline.dev/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 7, 1),
        totalValueLocked: 450000,
        activeUsers: 2000,
        socialLinks: {
          'twitter': 'https://twitter.com/headline_dev',
          'medium': 'https://medium.com/@headline',
        },
        tokenSymbol: 'HDL',
        tokenPrice: 0.0045,
        marketCap: 4500000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'xfinite',
        name: 'Xfinite Entertainment Token',
        description:
            'Xfinite is an entertainment platform that creates and distributes digital content. It uses blockchain technology to ensure fair compensation for creators and transparent content distribution.',
        shortDescription: 'Entertainment platform for digital content',
        category: ProjectCategory.nft,
        website: 'https://xfinite.io',
        logoUrl: 'https://xfinite.io/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 9, 1),
        totalValueLocked: 600000,
        activeUsers: 4000,
        socialLinks: {
          'twitter': 'https://twitter.com/xfinite',
          'youtube': 'https://youtube.com/xfinite',
        },
        tokenSymbol: 'XET',
        tokenPrice: 0.0006,
        marketCap: 6000000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'defly',
        name: 'Defly',
        description:
            'Defly is a DeFi aggregator that helps users find the best yields and trading opportunities across the Algorand ecosystem. It provides a unified interface for various DeFi protocols.',
        shortDescription: 'DeFi aggregator for Algorand ecosystem',
        category: ProjectCategory.defi,
        website: 'https://defly.app',
        logoUrl: 'https://defly.app/logo.png',
        isVerified: true,
        launchDate: DateTime(2021, 11, 1),
        totalValueLocked: 1800000,
        activeUsers: 6000,
        socialLinks: {
          'twitter': 'https://twitter.com/defly_app',
          'telegram': 'https://t.me/defly',
        },
        tokenSymbol: 'DEFLY',
        tokenPrice: 0.0018,
        marketCap: 1800000,
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'folks-finance',
        name: 'Folks Finance',
        description:
            'Folks Finance is a lending protocol that allows users to borrow and lend assets on Algorand. It provides competitive interest rates and flexible borrowing options.',
        shortDescription: 'Lending protocol for Algorand assets',
        category: ProjectCategory.defi,
        website: 'https://folks.finance',
        logoUrl: 'https://folks.finance/logo.png',
        isVerified: true,
        launchDate: DateTime(2022, 1, 1),
        totalValueLocked: 15000000,
        activeUsers: 8000,
        socialLinks: {
          'twitter': 'https://twitter.com/folks_finance',
          'discord': 'https://discord.gg/folks',
        },
        lastUpdated: now,
      ),
      ProjectModel(
        id: 'algofi',
        name: 'Algofi',
        description:
            'Algofi is a comprehensive DeFi platform that offers lending, borrowing, and yield farming opportunities. It provides a complete suite of DeFi services on Algorand.',
        shortDescription: 'Comprehensive DeFi platform',
        category: ProjectCategory.defi,
        website: 'https://algofi.org',
        logoUrl: 'https://algofi.org/logo.png',
        isVerified: true,
        launchDate: DateTime(2022, 2, 1),
        totalValueLocked: 22000000,
        activeUsers: 12000,
        socialLinks: {
          'twitter': 'https://twitter.com/algofi',
          'discord': 'https://discord.gg/algofi',
        },
        lastUpdated: now,
      ),
    ];
  }
}
