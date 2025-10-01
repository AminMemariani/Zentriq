import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zentriq/core/errors/failures.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/domain/entities/project.dart';
import 'package:zentriq/viewmodels/ecosystem_viewmodel.dart';

import '../mocks/mock_repositories.mocks.dart';

void main() {
  group('EcosystemViewModel', () {
    late EcosystemViewModel viewModel;
    late MockGetAllProjects mockGetAllProjects;
    late MockGetFeaturedProjects mockGetFeaturedProjects;

    setUp(() {
      mockGetAllProjects = MockGetAllProjects();
      mockGetFeaturedProjects = MockGetFeaturedProjects();
      viewModel = EcosystemViewModel(
        mockGetAllProjects,
        mockGetFeaturedProjects,
      );
    });

    group('Initial State', () {
      test('should have correct initial values', () {
        expect(viewModel.allProjects, isEmpty);
        expect(viewModel.featuredProjects, isEmpty);
        expect(viewModel.isLoadingAllProjects, isFalse);
        expect(viewModel.isLoadingFeaturedProjects, isFalse);
        expect(viewModel.allProjectsErrorMessage, isNull);
        expect(viewModel.featuredProjectsErrorMessage, isNull);
        expect(viewModel.searchQuery, isEmpty);
        expect(viewModel.selectedCategory, isNull);
      });
    });

    group('Load All Projects', () {
      test('should load all projects successfully', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'Project Alpha',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));

        // Act
        await viewModel.loadAllProjects();

        // Assert
        expect(viewModel.allProjects, tProjects);
        expect(viewModel.isLoadingAllProjects, false);
        expect(viewModel.allProjectsErrorMessage, isNull);
        verify(mockGetAllProjects.call()).called(1);
      });

      test('should handle all projects loading error', () async {
        // Arrange
        final failure = ServerFailure('error');
        provideDummy<Result<List<Project>>>(Result.failure(failure));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadAllProjects();

        // Assert
        expect(viewModel.allProjects, isEmpty);
        expect(viewModel.isLoadingAllProjects, false);
        expect(viewModel.allProjectsErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetAllProjects.call()).called(1);
      });
    });

    group('Load Featured Projects', () {
      test('should load featured projects successfully', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'Featured Project',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetFeaturedProjects.call(any))
            .thenAnswer((_) async => Result.success(tProjects));

        // Act
        await viewModel.loadFeaturedProjects();

        // Assert
        expect(viewModel.featuredProjects, tProjects);
        expect(viewModel.isLoadingFeaturedProjects, false);
        expect(viewModel.featuredProjectsErrorMessage, isNull);
        verify(mockGetFeaturedProjects.call(any)).called(1);
      });

      test('should handle featured projects loading error', () async {
        // Arrange
        final failure = NetworkFailure('error');
        provideDummy<Result<List<Project>>>(Result.failure(failure));
        when(mockGetFeaturedProjects.call(any))
            .thenAnswer((_) async => Result.failure(failure));

        // Act
        await viewModel.loadFeaturedProjects();

        // Assert
        expect(viewModel.featuredProjects, isEmpty);
        expect(viewModel.isLoadingFeaturedProjects, false);
        expect(viewModel.featuredProjectsErrorMessage, 'An unexpected error occurred. Please try again.');
        verify(mockGetFeaturedProjects.call(any)).called(1);
      });
    });

    group('Filtering', () {
      test('should filter projects by category', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'DeFi Project',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
          Project(
            id: 'p2',
            name: 'NFT Project',
            description: 'Description 2',
            shortDescription: 'Short Desc 2',
            logoUrl: 'logo2.png',
            category: ProjectCategory.nft,
            website: 'web2.com',
            isVerified: false,
            launchDate: DateTime(2022, 2, 1),
            totalValueLocked: 500000,
            activeUsers: 500,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));
        await viewModel.loadAllProjects();

        // Act
        viewModel.setCategoryFilter(ProjectCategory.defi);
        final filteredProjects = viewModel.getFilteredProjects();

        // Assert
        expect(filteredProjects, [tProjects[0]]);
      });

      test('should filter projects by search query', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'Alpha Project',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));
        await viewModel.loadAllProjects();

        // Act
        viewModel.setSearchQuery('alpha');
        final filteredProjects = viewModel.getFilteredProjects();

        // Assert
        expect(filteredProjects, [tProjects[0]]);
      });

      test('should clear filters', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'Project Alpha',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));
        await viewModel.loadAllProjects();

        // Set some filters
        viewModel.setCategoryFilter(ProjectCategory.defi);
        viewModel.setSearchQuery('alpha');

        // Act
        viewModel.clearFilters();

        // Assert
        expect(viewModel.selectedCategory, isNull);
        expect(viewModel.searchQuery, isEmpty);
        expect(viewModel.getFilteredProjects(), tProjects);
      });
    });

    group('Utility Methods', () {
      test('should get projects by category', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'DeFi Project',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));
        await viewModel.loadAllProjects();

        // Act
        final defiProjects = viewModel.getProjectsByCategory(ProjectCategory.defi);

        // Assert
        expect(defiProjects, [tProjects[0]]);
      });

      test('should get ecosystem stats', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'Project Alpha',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));
        await viewModel.loadAllProjects();

        // Act
        final stats = viewModel.getEcosystemStats();

        // Assert
        expect(stats['totalProjects'], 1);
        expect(stats['totalTVL'], 1000000);
        expect(stats['totalActiveUsers'], 1000);
      });
    });

    group('Refresh Projects', () {
      test('should refresh both all projects and featured projects', () async {
        // Arrange
        final tProjects = [
          Project(
            id: 'p1',
            name: 'Project Alpha',
            description: 'Description 1',
            shortDescription: 'Short Desc 1',
            logoUrl: 'logo1.png',
            category: ProjectCategory.defi,
            website: 'web1.com',
            isVerified: true,
            launchDate: DateTime(2022, 1, 1),
            totalValueLocked: 1000000,
            activeUsers: 1000,
            socialLinks: {},
          ),
        ];
        
        provideDummy<Result<List<Project>>>(Result.success(tProjects));
        when(mockGetAllProjects.call())
            .thenAnswer((_) async => Result.success(tProjects));
        when(mockGetFeaturedProjects.call(any))
            .thenAnswer((_) async => Result.success(tProjects));

        // Act
        await viewModel.refreshProjects();

        // Assert
        verify(mockGetAllProjects.call()).called(1);
        verify(mockGetFeaturedProjects.call(any)).called(1);
      });
    });
  });
}
