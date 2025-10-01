import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../core/utils/result.dart';
import '../../core/utils/use_case.dart';

/// Use case for getting the current user
class GetCurrentUser extends UseCaseNoParams<User> {
  GetCurrentUser(this._repository);

  final UserRepository _repository;

  @override
  Future<Result<User>> call() {
    return _repository.getCurrentUser();
  }
}
