import 'package:flutter/foundation.dart';
import '../domain/entities/project.dart';
import '../domain/usecases/get_all_projects.dart';
import '../domain/usecases/get_featured_projects.dart';
import '../core/errors/failures.dart' as failures;

/// ViewModel for ecosystem project-related operations using Provider
class EcosystemViewModel extends ChangeNotifier {
  EcosystemViewModel(this._getAllProjects, this._getFeaturedProjects);

  final GetAllProjects _getAllProjects;
  final GetFeaturedProjects _getFeaturedProjects;

  // Project state
  List<Project> _allProjects = [];
  List<Project> _featuredProjects = [];
  bool _isLoadingAllProjects = false;
  bool _isLoadingFeaturedProjects = false;
  String? _allProjectsErrorMessage;
  String? _featuredProjectsErrorMessage;

  // Filter state
  ProjectCategory? _selectedCategory;
  String _searchQuery = '';

  // Getters
  List<Project> get allProjects => _allProjects;
  List<Project> get featuredProjects => _featuredProjects;
  bool get isLoadingAllProjects => _isLoadingAllProjects;
  bool get isLoadingFeaturedProjects => _isLoadingFeaturedProjects;
  String? get allProjectsErrorMessage => _allProjectsErrorMessage;
  String? get featuredProjectsErrorMessage => _featuredProjectsErrorMessage;
  bool get hasAllProjectsError => _allProjectsErrorMessage != null;
  bool get hasFeaturedProjectsError => _featuredProjectsErrorMessage != null;
  ProjectCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Loads all projects
  Future<void> loadAllProjects() async {
    _setAllProjectsLoading(true);
    _clearAllProjectsError();

    final result = await _getAllProjects();

    result
        .onSuccess((projects) {
          _allProjects = projects;
          notifyListeners();
        })
        .onFailure((failure) {
          _setAllProjectsError(_getErrorMessage(failure));
        });

    _setAllProjectsLoading(false);
  }

  /// Loads featured projects
  Future<void> loadFeaturedProjects({int limit = 10}) async {
    _setFeaturedProjectsLoading(true);
    _clearFeaturedProjectsError();

    final params = GetFeaturedProjectsParams(limit: limit);
    final result = await _getFeaturedProjects(params);

    result
        .onSuccess((projects) {
          _featuredProjects = projects;
          notifyListeners();
        })
        .onFailure((failure) {
          _setFeaturedProjectsError(_getErrorMessage(failure));
        });

    _setFeaturedProjectsLoading(false);
  }

  /// Refreshes all project data
  Future<void> refreshProjects() async {
    await Future.wait([loadAllProjects(), loadFeaturedProjects()]);
  }

  /// Sets the selected category filter
  void setCategoryFilter(ProjectCategory? category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// Sets the search query
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Clears all filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Gets filtered projects based on current filters
  List<Project> getFilteredProjects() {
    List<Project> filteredProjects = List.from(_allProjects);

    // Apply category filter
    if (_selectedCategory != null) {
      filteredProjects = filteredProjects
          .where((project) => project.category == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final lowercaseQuery = _searchQuery.toLowerCase();
      filteredProjects = filteredProjects.where((project) {
        return project.name.toLowerCase().contains(lowercaseQuery) ||
            project.description.toLowerCase().contains(lowercaseQuery) ||
            project.shortDescription.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }

    return filteredProjects;
  }

  /// Gets projects by category
  List<Project> getProjectsByCategory(ProjectCategory category) {
    return _allProjects
        .where((project) => project.category == category)
        .toList();
  }

  /// Gets recently launched projects
  List<Project> getRecentlyLaunchedProjects({int limit = 10}) {
    final sortedProjects = List<Project>.from(_allProjects);
    sortedProjects.sort((a, b) => b.launchDate.compareTo(a.launchDate));
    return sortedProjects.take(limit).toList();
  }

  /// Gets popular projects
  List<Project> getPopularProjects({int limit = 10}) {
    final popularProjects = _allProjects
        .where((project) => project.isPopular)
        .toList();
    popularProjects.sort((a, b) {
      final aScore = a.totalValueLocked + (a.activeUsers * 100);
      final bScore = b.totalValueLocked + (b.activeUsers * 100);
      return bScore.compareTo(aScore);
    });
    return popularProjects.take(limit).toList();
  }

  /// Gets verified projects
  List<Project> getVerifiedProjects() {
    return _allProjects.where((project) => project.isVerified).toList();
  }

  /// Gets projects with tokens
  List<Project> getProjectsWithTokens() {
    return _allProjects.where((project) => project.hasToken).toList();
  }

  /// Searches projects by query
  List<Project> searchProjects(String query) {
    if (query.isEmpty) return _allProjects;

    final lowercaseQuery = query.toLowerCase();
    return _allProjects.where((project) {
      return project.name.toLowerCase().contains(lowercaseQuery) ||
          project.description.toLowerCase().contains(lowercaseQuery) ||
          project.shortDescription.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Gets project by ID
  Project? getProjectById(String id) {
    try {
      return _allProjects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets category statistics
  Map<ProjectCategory, int> getCategoryStats() {
    final stats = <ProjectCategory, int>{};
    for (final category in ProjectCategory.values) {
      stats[category] = _allProjects
          .where((project) => project.category == category)
          .length;
    }
    return stats;
  }

  /// Gets total ecosystem statistics
  Map<String, dynamic> getEcosystemStats() {
    final totalProjects = _allProjects.length;
    final verifiedProjects = _allProjects.where((p) => p.isVerified).length;
    final projectsWithTokens = _allProjects.where((p) => p.hasToken).length;
    final totalTVL = _allProjects.fold<double>(
      0,
      (sum, project) => sum + project.totalValueLocked,
    );
    final totalActiveUsers = _allProjects.fold<int>(
      0,
      (sum, project) => sum + project.activeUsers,
    );

    return {
      'totalProjects': totalProjects,
      'verifiedProjects': verifiedProjects,
      'projectsWithTokens': projectsWithTokens,
      'totalTVL': totalTVL,
      'totalActiveUsers': totalActiveUsers,
    };
  }

  // Private methods for state management
  void _setAllProjectsLoading(bool loading) {
    _isLoadingAllProjects = loading;
    notifyListeners();
  }

  void _setAllProjectsError(String message) {
    _allProjectsErrorMessage = message;
    notifyListeners();
  }

  void _clearAllProjectsError() {
    _allProjectsErrorMessage = null;
  }

  void _setFeaturedProjectsLoading(bool loading) {
    _isLoadingFeaturedProjects = loading;
    notifyListeners();
  }

  void _setFeaturedProjectsError(String message) {
    _featuredProjectsErrorMessage = message;
    notifyListeners();
  }

  void _clearFeaturedProjectsError() {
    _featuredProjectsErrorMessage = null;
  }

  /// Converts a failure to a user-friendly error message
  String _getErrorMessage(failures.Failure failure) {
    switch (failure.runtimeType) {
      case failures.NetworkFailure _:
        return 'No internet connection. Please check your network.';
      case failures.ServerFailure _:
        return 'Server error. Please try again later.';
      case failures.CacheFailure _:
        return 'Failed to load data from cache.';
      case failures.ValidationFailure _:
        return 'Invalid data. Please check your input.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
