import 'package:flutter/foundation.dart';
import '../core/constants/app_enums.dart';

/// Main ViewModel for managing navigation state and app-wide state
class MainViewModel extends ChangeNotifier {
  MainViewModel() {
    _currentPage = AppPage.wallet;
  }

  AppPage _currentPage = AppPage.wallet;
  int _currentIndex = 0;

  /// Current active page
  AppPage get currentPage => _currentPage;

  /// Current bottom navigation index
  int get currentIndex => _currentIndex;

  /// Whether the app is in loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Whether the app has an error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Changes the current page and updates the navigation index
  void changePage(AppPage page) {
    if (_currentPage != page) {
      _currentPage = page;
      _currentIndex = page.index;
      notifyListeners();
    }
  }

  /// Changes the current page by index
  void changePageByIndex(int index) {
    if (index >= 0 && index < AppPage.values.length) {
      final page = AppPage.values[index];
      changePage(page);
    }
  }

  /// Sets the loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Sets an error message
  void setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  /// Clears the error message
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Resets the app state
  void reset() {
    _currentPage = AppPage.wallet;
    _currentIndex = 0;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
