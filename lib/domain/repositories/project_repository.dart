import '../entities/project.dart';
import '../../core/utils/result.dart';

/// Abstract repository for project-related operations
abstract class ProjectRepository {
  /// Gets all projects
  Future<Result<List<Project>>> getAllProjects();

  /// Gets projects by category
  Future<Result<List<Project>>> getProjectsByCategory(ProjectCategory category);

  /// Gets featured projects
  Future<Result<List<Project>>> getFeaturedProjects({int limit = 10});

  /// Gets recently launched projects
  Future<Result<List<Project>>> getRecentlyLaunchedProjects({int limit = 10});

  /// Gets popular projects (high TVL or active users)
  Future<Result<List<Project>>> getPopularProjects({int limit = 10});

  /// Gets project by ID
  Future<Result<Project>> getProjectById(String id);

  /// Searches projects by name or description
  Future<Result<List<Project>>> searchProjects(String query);

  /// Refreshes project data
  Future<Result<List<Project>>> refreshProjects();
}
