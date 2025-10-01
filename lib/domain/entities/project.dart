import 'package:equatable/equatable.dart';

/// Project entity representing an Algorand ecosystem project or dApp
class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.category,
    required this.website,
    required this.logoUrl,
    required this.isVerified,
    required this.launchDate,
    required this.totalValueLocked,
    required this.activeUsers,
    required this.socialLinks,
    this.tokenSymbol,
    this.tokenPrice,
    this.marketCap,
    this.lastUpdated,
  });

  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final ProjectCategory category;
  final String website;
  final String logoUrl;
  final bool isVerified;
  final DateTime launchDate;
  final double totalValueLocked;
  final int activeUsers;
  final Map<String, String> socialLinks;
  final String? tokenSymbol;
  final double? tokenPrice;
  final double? marketCap;
  final DateTime? lastUpdated;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    shortDescription,
    category,
    website,
    logoUrl,
    isVerified,
    launchDate,
    totalValueLocked,
    activeUsers,
    socialLinks,
    tokenSymbol,
    tokenPrice,
    marketCap,
    lastUpdated,
  ];

  /// Returns formatted TVL with currency symbol
  String get formattedTVL => _formatLargeNumber(totalValueLocked);

  /// Returns formatted market cap
  String get formattedMarketCap =>
      marketCap != null ? _formatLargeNumber(marketCap!) : 'N/A';

  /// Returns formatted token price
  String get formattedTokenPrice =>
      tokenPrice != null ? '\$${tokenPrice!.toStringAsFixed(4)}' : 'N/A';

  /// Returns formatted active users
  String get formattedActiveUsers => _formatLargeNumber(activeUsers.toDouble());

  /// Returns formatted launch date
  String get formattedLaunchDate {
    final now = DateTime.now();
    final difference = now.difference(launchDate);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return 'Recently launched';
    }
  }

  /// Returns true if the project has a token
  bool get hasToken => tokenSymbol != null && tokenSymbol!.isNotEmpty;

  /// Returns true if the project is recently launched (within 30 days)
  bool get isRecentlyLaunched {
    final now = DateTime.now();
    final difference = now.difference(launchDate);
    return difference.inDays <= 30;
  }

  /// Returns true if the project is popular (high TVL or active users)
  bool get isPopular => totalValueLocked > 1000000 || activeUsers > 10000;

  /// Returns the primary social link (Twitter if available, otherwise first available)
  String? get primarySocialLink {
    if (socialLinks.containsKey('twitter')) {
      return socialLinks['twitter'];
    }
    return socialLinks.isNotEmpty ? socialLinks.values.first : null;
  }

  /// Formats large numbers with K, M, B suffixes
  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '\$${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '\$${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '\$${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '\$${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return '\$${number.toStringAsFixed(2)}';
    }
  }

  /// Creates a copy of this project with the given fields replaced with new values
  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    ProjectCategory? category,
    String? website,
    String? logoUrl,
    bool? isVerified,
    DateTime? launchDate,
    double? totalValueLocked,
    int? activeUsers,
    Map<String, String>? socialLinks,
    String? tokenSymbol,
    double? tokenPrice,
    double? marketCap,
    DateTime? lastUpdated,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      category: category ?? this.category,
      website: website ?? this.website,
      logoUrl: logoUrl ?? this.logoUrl,
      isVerified: isVerified ?? this.isVerified,
      launchDate: launchDate ?? this.launchDate,
      totalValueLocked: totalValueLocked ?? this.totalValueLocked,
      activeUsers: activeUsers ?? this.activeUsers,
      socialLinks: socialLinks ?? this.socialLinks,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      tokenPrice: tokenPrice ?? this.tokenPrice,
      marketCap: marketCap ?? this.marketCap,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Project category enum
enum ProjectCategory {
  defi,
  nft,
  gaming,
  social,
  infrastructure,
  governance,
  payments,
  identity,
  supplyChain,
  other,
}

/// Extension to get display names for project categories
extension ProjectCategoryExtension on ProjectCategory {
  String get displayName {
    switch (this) {
      case ProjectCategory.defi:
        return 'DeFi';
      case ProjectCategory.nft:
        return 'NFT';
      case ProjectCategory.gaming:
        return 'Gaming';
      case ProjectCategory.social:
        return 'Social';
      case ProjectCategory.infrastructure:
        return 'Infrastructure';
      case ProjectCategory.governance:
        return 'Governance';
      case ProjectCategory.payments:
        return 'Payments';
      case ProjectCategory.identity:
        return 'Identity';
      case ProjectCategory.supplyChain:
        return 'Supply Chain';
      case ProjectCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case ProjectCategory.defi:
        return '🏦';
      case ProjectCategory.nft:
        return '🎨';
      case ProjectCategory.gaming:
        return '🎮';
      case ProjectCategory.social:
        return '👥';
      case ProjectCategory.infrastructure:
        return '⚙️';
      case ProjectCategory.governance:
        return '🗳️';
      case ProjectCategory.payments:
        return '💳';
      case ProjectCategory.identity:
        return '🆔';
      case ProjectCategory.supplyChain:
        return '📦';
      case ProjectCategory.other:
        return '🔧';
    }
  }
}
