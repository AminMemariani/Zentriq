import '../../domain/entities/project.dart';

/// Project model for data layer
class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.shortDescription,
    required super.category,
    required super.website,
    required super.logoUrl,
    required super.isVerified,
    required super.launchDate,
    required super.totalValueLocked,
    required super.activeUsers,
    required super.socialLinks,
    super.tokenSymbol,
    super.tokenPrice,
    super.marketCap,
    super.lastUpdated,
  });

  /// Creates a ProjectModel from a JSON map
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String,
      category: ProjectCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ProjectCategory.other,
      ),
      website: json['website'] as String,
      logoUrl: json['logo_url'] as String,
      isVerified: json['is_verified'] as bool,
      launchDate: DateTime.parse(json['launch_date'] as String),
      totalValueLocked: (json['total_value_locked'] as num).toDouble(),
      activeUsers: json['active_users'] as int,
      socialLinks: Map<String, String>.from(json['social_links'] as Map),
      tokenSymbol: json['token_symbol'] as String?,
      tokenPrice: json['token_price'] != null
          ? (json['token_price'] as num).toDouble()
          : null,
      marketCap: json['market_cap'] != null
          ? (json['market_cap'] as num).toDouble()
          : null,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'] as String)
          : null,
    );
  }

  /// Converts this ProjectModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'short_description': shortDescription,
      'category': category.name,
      'website': website,
      'logo_url': logoUrl,
      'is_verified': isVerified,
      'launch_date': launchDate.toIso8601String(),
      'total_value_locked': totalValueLocked,
      'active_users': activeUsers,
      'social_links': socialLinks,
      'token_symbol': tokenSymbol,
      'token_price': tokenPrice,
      'market_cap': marketCap,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Creates a ProjectModel from a Project entity
  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      shortDescription: project.shortDescription,
      category: project.category,
      website: project.website,
      logoUrl: project.logoUrl,
      isVerified: project.isVerified,
      launchDate: project.launchDate,
      totalValueLocked: project.totalValueLocked,
      activeUsers: project.activeUsers,
      socialLinks: project.socialLinks,
      tokenSymbol: project.tokenSymbol,
      tokenPrice: project.tokenPrice,
      marketCap: project.marketCap,
      lastUpdated: project.lastUpdated,
    );
  }
}
