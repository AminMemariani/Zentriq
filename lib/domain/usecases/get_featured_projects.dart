import '../entities/project.dart';
import '../repositories/project_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Parameters for getting featured projects
class GetFeaturedProjectsParams {
  const GetFeaturedProjectsParams({this.limit = 10});

  final int limit;
}

/// Use case for getting featured projects
class GetFeaturedProjects
    extends UseCase<List<Project>, GetFeaturedProjectsParams> {
  GetFeaturedProjects(this._repository);

  final ProjectRepository _repository;

  @override
  Future<Result<List<Project>>> call(GetFeaturedProjectsParams params) {
    return _repository.getFeaturedProjects(limit: params.limit);
  }
}
