import 'package:equatable/equatable.dart';
import '../errors/failures.dart' as failures;

/// A generic result class that can represent either success or failure
sealed class Result<T> extends Equatable {
  const Result();

  /// Creates a success result with the given data
  const factory Result.success(T data) = Success<T>;

  /// Creates a failure result with the given failure
  const factory Result.failure(failures.Failure failure) = ResultFailure<T>;

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is ResultFailure<T>;

  /// Returns the data if this is a success result, null otherwise
  T? get data => isSuccess ? (this as Success<T>).data : null;

  /// Returns the failure if this is a failure result, null otherwise
  failures.Failure? get failure =>
      isFailure ? (this as ResultFailure<T>).failure : null;

  /// Transforms the data if this is a success result
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform((this as Success<T>).data));
      } catch (e) {
        return Result.failure(failures.UnknownFailure(e.toString()));
      }
    }
    return Result.failure((this as ResultFailure<T>).failure);
  }

  /// Executes a function if this is a success result
  Result<T> onSuccess(void Function(T data) action) {
    if (isSuccess) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Executes a function if this is a failure result
  Result<T> onFailure(void Function(failures.Failure failure) action) {
    if (isFailure) {
      action((this as ResultFailure<T>).failure);
    }
    return this;
  }

  /// Returns the data if this is a success result, or the default value if it's a failure
  T getOrElse(T defaultValue) {
    return isSuccess ? (this as Success<T>).data : defaultValue;
  }

  /// Returns the data if this is a success result, or the result of the function if it's a failure
  T getOrElseWith(T Function(failures.Failure failure) defaultValue) {
    return isSuccess
        ? (this as Success<T>).data
        : defaultValue((this as ResultFailure<T>).failure);
  }
}

/// Represents a successful result
class Success<T> extends Result<T> {
  const Success(this.data);

  @override
  final T data;

  @override
  List<Object?> get props => [data];
}

/// Represents a failed result
class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  @override
  final failures.Failure failure;

  @override
  List<Object?> get props => [failure];
}
