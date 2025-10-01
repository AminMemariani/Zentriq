import '../entities/user.dart';
import '../../core/utils/result.dart';

/// Abstract repository for user-related operations
abstract class UserRepository {
  /// Gets the current user
  Future<Result<User>> getCurrentUser();

  /// Gets a user by ID
  Future<Result<User>> getUserById(String id);

  /// Updates the current user
  Future<Result<User>> updateUser(User user);

  /// Deletes the current user
  Future<Result<void>> deleteUser();

  /// Signs out the current user
  Future<Result<void>> signOut();
}

