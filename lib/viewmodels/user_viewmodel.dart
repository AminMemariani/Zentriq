import 'package:flutter/foundation.dart';
import '../domain/entities/user.dart';
import '../domain/usecases/get_current_user.dart';
import '../core/errors/failures.dart' as failures;

/// ViewModel for user-related operations using Provider
class UserViewModel extends ChangeNotifier {
  UserViewModel(this._getCurrentUser);

  final GetCurrentUser _getCurrentUser;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  /// Current user data
  User? get user => _user;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get errorMessage => _errorMessage;

  /// Whether there's an error
  bool get hasError => _errorMessage != null;

  /// Loads the current user
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _clearError();

    final result = await _getCurrentUser();

    result
        .onSuccess((user) {
          _user = user;
          notifyListeners();
        })
        .onFailure((failure) {
          _setError(_getErrorMessage(failure));
        });

    _setLoading(false);
  }

  /// Refreshes the current user data
  Future<void> refreshUser() async {
    await loadCurrentUser();
  }

  /// Clears the current user data
  void clearUser() {
    _user = null;
    _clearError();
    notifyListeners();
  }

  /// Sets the loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets an error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears the error message
  void _clearError() {
    _errorMessage = null;
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
