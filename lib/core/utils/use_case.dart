import 'package:equatable/equatable.dart';
import 'result.dart';

/// Base class for all use cases
abstract class UseCase<Type, Params> {
  /// Executes the use case with the given parameters
  Future<Result<Type>> call(Params params);
}

/// Use case that doesn't require parameters
abstract class UseCaseNoParams<Type> {
  /// Executes the use case without parameters
  Future<Result<Type>> call();
}

/// Parameters class for use cases that don't require parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
