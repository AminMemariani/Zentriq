import 'package:flutter/foundation.dart';
import '../errors/failures.dart' as failures;

/// Base ViewModel class with common functionality for all ViewModels
abstract class BaseViewModel extends ChangeNotifier {
  /// Error message for the current state
  String? _errorMessage;

  /// Whether the ViewModel is currently loading
  bool _isLoading = false;

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Getter for loading state
  bool get isLoading => _isLoading;

  /// Set loading state and notify listeners
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message and notify listeners
  void setError(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      notifyListeners();
    }
  }

  /// Clear error message and notify listeners
  void clearError() {
    setError(null);
  }

  /// Handle failure and convert to user-friendly error message
  void handleFailure(failures.Failure failure) {
    setError(_getErrorMessage(failure));
  }

  /// Convert failure to user-friendly error message
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

  /// Execute an async operation with loading and error handling
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    bool Function(T)? onSuccess,
    void Function(failures.Failure)? onFailure,
  }) async {
    try {
      setLoading(true);
      clearError();

      final result = await operation();

      if (onSuccess != null && !onSuccess(result)) {
        return result;
      }

      return result;
    } catch (e) {
      final failure = failures.ServerFailure(e.toString());
      handleFailure(failure);
      onFailure?.call(failure);
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Execute an async operation that returns a Result
  Future<T?> executeResultOperation<T>(
    Future<Result<T>> Function() operation, {
    void Function(T)? onSuccess,
    void Function(failures.Failure)? onFailure,
  }) async {
    try {
      setLoading(true);
      clearError();

      final result = await operation();

      return result.when(
        success: (data) {
          onSuccess?.call(data);
          return data;
        },
        failure: (failure) {
          handleFailure(failure);
          onFailure?.call(failure);
          return null;
        },
      );
    } finally {
      setLoading(false);
    }
  }

}

/// Result type for handling success and failure states
abstract class Result<T> {
  const Result();

  /// Create a successful result
  factory Result.success(T data) = Success<T>;

  /// Create a failed result
  factory Result.failure(failures.Failure failure) = Failure<T>;

  /// Check if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the data if successful, null otherwise
  T? get data => isSuccess ? (this as Success<T>).data : null;

  /// Get the failure if failed, null otherwise
  failures.Failure? get failure =>
      isFailure ? (this as Failure<T>).failure : null;

  /// Handle the result with success and failure callbacks
  R when<R>({
    required R Function(T) success,
    required R Function(failures.Failure) failure,
  }) {
    if (isSuccess) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as Failure<T>).failure);
    }
  }

  /// Handle the result with optional callbacks
  void onSuccess(void Function(T) callback) {
    if (isSuccess) {
      callback((this as Success<T>).data);
    }
  }

  /// Handle the result with optional failure callback
  void onFailure(void Function(failures.Failure) callback) {
    if (isFailure) {
      callback((this as Failure<T>).failure);
    }
  }
}

/// Successful result
class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

/// Failed result
class Failure<T> extends Result<T> {
  @override
  final failures.Failure failure;
  const Failure(this.failure);
}
