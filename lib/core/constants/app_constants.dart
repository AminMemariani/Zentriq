/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App information
  static const String appName = 'Zentriq';
  static const String appVersion = '1.0.0';

  // API constants
  static const String baseUrl = 'https://api.zentriq.com';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxEmailLength = 254;

  // Error messages
  static const String networkErrorMessage = 'No internet connection';
  static const String serverErrorMessage = 'Server error occurred';
  static const String unknownErrorMessage = 'An unknown error occurred';
  static const String validationErrorMessage = 'Validation failed';
}

