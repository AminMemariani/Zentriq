import 'package:flutter_test/flutter_test.dart';
import 'package:zentriq/data/models/project_model.dart';
import 'package:zentriq/domain/entities/project.dart';

void main() {
  group('ProjectModel', () {
    final testProject = ProjectModel(
      id: '1',
      name: 'Test Project',
      description: 'This is a test project description',
      shortDescription: 'Test project',
      category: ProjectCategory.defi,
      website: 'https://testproject.com',
      logoUrl: 'https://testproject.com/logo.png',
      isVerified: true,
      launchDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
      totalValueLocked: 1000000.0,
      activeUsers: 5000,
      socialLinks: {'twitter': 'https://twitter.com/testproject'},
      tokenSymbol: 'TEST',
      tokenPrice: 1.5,
      marketCap: 5000000.0,
      lastUpdated: DateTime.parse('2023-01-01T12:00:00.000Z'),
    );

    const testJson = {
      'id': '1',
      'name': 'Test Project',
      'description': 'This is a test project description',
      'short_description': 'Test project',
      'category': 'defi',
      'website': 'https://testproject.com',
      'logo_url': 'https://testproject.com/logo.png',
      'is_verified': true,
      'launch_date': '2023-01-01T00:00:00.000Z',
      'total_value_locked': 1000000.0,
      'active_users': 5000,
      'social_links': {'twitter': 'https://twitter.com/testproject'},
      'token_symbol': 'TEST',
      'token_price': 1.5,
      'market_cap': 5000000.0,
      'last_updated': '2023-01-01T12:00:00.000Z',
    };

    test('should create ProjectModel from JSON', () {
      // Act
      final result = ProjectModel.fromJson(testJson);

      // Assert
      expect(result.id, '1');
      expect(result.name, 'Test Project');
      expect(result.description, 'This is a test project description');
      expect(result.shortDescription, 'Test project');
      expect(result.category, ProjectCategory.defi);
      expect(result.website, 'https://testproject.com');
      expect(result.logoUrl, 'https://testproject.com/logo.png');
      expect(result.isVerified, true);
      expect(result.launchDate, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(result.totalValueLocked, 1000000.0);
      expect(result.activeUsers, 5000);
      expect(
          result.socialLinks, {'twitter': 'https://twitter.com/testproject'});
      expect(result.tokenSymbol, 'TEST');
      expect(result.tokenPrice, 1.5);
      expect(result.marketCap, 5000000.0);
      expect(result.lastUpdated, DateTime.parse('2023-01-01T12:00:00.000Z'));
    });

    test('should create ProjectModel from JSON with minimal data', () {
      // Arrange
      const minimalJson = {
        'id': '2',
        'name': 'Minimal Project',
        'description': 'Minimal description',
        'short_description': 'Minimal',
        'category': 'other',
        'website': 'https://minimal.com',
        'logo_url': 'https://minimal.com/logo.png',
        'is_verified': false,
        'launch_date': '2023-01-01T00:00:00.000Z',
        'total_value_locked': 0.0,
        'active_users': 0,
        'social_links': {},
      };

      // Act
      final result = ProjectModel.fromJson(minimalJson);

      // Assert
      expect(result.id, '2');
      expect(result.name, 'Minimal Project');
      expect(result.category, ProjectCategory.other);
      expect(result.isVerified, false);
      expect(result.totalValueLocked, 0.0);
      expect(result.activeUsers, 0);
      expect(result.socialLinks, {});
      expect(result.tokenSymbol, null);
      expect(result.tokenPrice, null);
      expect(result.marketCap, null);
      expect(result.lastUpdated, null);
    });

    test('should convert ProjectModel to JSON', () {
      // Act
      final result = testProject.toJson();

      // Assert
      expect(result['id'], '1');
      expect(result['name'], 'Test Project');
      expect(result['description'], 'This is a test project description');
      expect(result['short_description'], 'Test project');
      expect(result['category'], 'defi');
      expect(result['website'], 'https://testproject.com');
      expect(result['logo_url'], 'https://testproject.com/logo.png');
      expect(result['is_verified'], true);
      expect(result['launch_date'], '2023-01-01T00:00:00.000Z');
      expect(result['total_value_locked'], 1000000.0);
      expect(result['active_users'], 5000);
      expect(result['social_links'],
          {'twitter': 'https://twitter.com/testproject'});
      expect(result['token_symbol'], 'TEST');
      expect(result['token_price'], 1.5);
      expect(result['market_cap'], 5000000.0);
      expect(result['last_updated'], '2023-01-01T12:00:00.000Z');
    });

    test('should create ProjectModel from Project entity', () {
      // Arrange
      final entity = Project(
        id: '3',
        name: 'Entity Project',
        description: 'Entity description',
        shortDescription: 'Entity',
        category: ProjectCategory.nft,
        website: 'https://entity.com',
        logoUrl: 'https://entity.com/logo.png',
        isVerified: true,
        launchDate: DateTime.parse('2023-01-01T00:00:00.000Z'),
        totalValueLocked: 2000000.0,
        activeUsers: 10000,
        socialLinks: {'discord': 'https://discord.gg/entity'},
        tokenSymbol: 'ENTITY',
        tokenPrice: 2.0,
        marketCap: 10000000.0,
        lastUpdated: DateTime.parse('2023-01-01T18:00:00.000Z'),
      );

      // Act
      final result = ProjectModel.fromEntity(entity);

      // Assert
      expect(result.id, '3');
      expect(result.name, 'Entity Project');
      expect(result.description, 'Entity description');
      expect(result.shortDescription, 'Entity');
      expect(result.category, ProjectCategory.nft);
      expect(result.website, 'https://entity.com');
      expect(result.logoUrl, 'https://entity.com/logo.png');
      expect(result.isVerified, true);
      expect(result.launchDate, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(result.totalValueLocked, 2000000.0);
      expect(result.activeUsers, 10000);
      expect(result.socialLinks, {'discord': 'https://discord.gg/entity'});
      expect(result.tokenSymbol, 'ENTITY');
      expect(result.tokenPrice, 2.0);
      expect(result.marketCap, 10000000.0);
      expect(result.lastUpdated, DateTime.parse('2023-01-01T18:00:00.000Z'));
    });

    test('should handle unknown category with default value', () {
      // Arrange
      const jsonWithUnknownCategory = {
        'id': '4',
        'name': 'Unknown Category Project',
        'description': 'Description',
        'short_description': 'Short',
        'category': 'unknown_category',
        'website': 'https://test.com',
        'logo_url': 'https://test.com/logo.png',
        'is_verified': true,
        'launch_date': '2023-01-01T00:00:00.000Z',
        'total_value_locked': 0.0,
        'active_users': 0,
        'social_links': {},
      };

      // Act
      final result = ProjectModel.fromJson(jsonWithUnknownCategory);

      // Assert
      expect(result.category, ProjectCategory.other);
    });

    test('should handle null optional fields in JSON', () {
      // Arrange
      const jsonWithNulls = {
        'id': '5',
        'name': 'Null Fields Project',
        'description': 'Description',
        'short_description': 'Short',
        'category': 'defi',
        'website': 'https://test.com',
        'logo_url': 'https://test.com/logo.png',
        'is_verified': true,
        'launch_date': '2023-01-01T00:00:00.000Z',
        'total_value_locked': 0.0,
        'active_users': 0,
        'social_links': {},
        'token_symbol': null,
        'token_price': null,
        'market_cap': null,
        'last_updated': null,
      };

      // Act
      final result = ProjectModel.fromJson(jsonWithNulls);

      // Assert
      expect(result.tokenSymbol, null);
      expect(result.tokenPrice, null);
      expect(result.marketCap, null);
      expect(result.lastUpdated, null);
    });
  });
}
