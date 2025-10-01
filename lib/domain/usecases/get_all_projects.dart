import '../entities/project.dart';
import '../repositories/project_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Use case for getting all projects
class GetAllProjects extends UseCaseNoParams<List<Project>> {
  GetAllProjects(this._repository);

  final ProjectRepository _repository;

  @override
  Future<Result<List<Project>>> call() {
    return _repository.getAllProjects();
  }
}
