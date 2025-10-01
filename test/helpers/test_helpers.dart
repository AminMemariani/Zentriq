import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:zentriq/core/utils/result.dart';
import 'package:zentriq/core/errors/failures.dart' as failures;

/// Test helper utilities for ViewModel testing
class TestHelpers {
  /// Creates a test widget with Provider for testing ViewModels
  static Widget createTestWidget({
    required Widget child,
    List<ChangeNotifierProvider> providers = const [],
  }) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  /// Waits for a ViewModel to finish loading
  static Future<void> waitForLoading<T extends ChangeNotifier>(
    T viewModel,
    bool Function(T) isLoading,
  ) async {
    while (isLoading(viewModel)) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Waits for a ViewModel to have data
  static Future<void> waitForData<T extends ChangeNotifier>(
    T viewModel,
    bool Function(T) hasData,
  ) async {
    while (!hasData(viewModel)) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Creates a successful Result
  static Result<T> createSuccessResult<T>(T data) {
    return Result.success(data);
  }

  /// Creates a failure Result
  static Result<T> createFailureResult<T>(failures.Failure failure) {
    return Result.failure(failure);
  }

  /// Creates a network failure
  static failures.NetworkFailure createNetworkFailure() {
    return failures.NetworkFailure('Network error');
  }

  /// Creates a server failure
  static failures.ServerFailure createServerFailure() {
    return failures.ServerFailure('Server error');
  }

  /// Creates a cache failure
  static failures.CacheFailure createCacheFailure() {
    return failures.CacheFailure('Cache error');
  }

  /// Creates a validation failure
  static failures.ValidationFailure createValidationFailure() {
    return failures.ValidationFailure('Validation error');
  }

  /// Verifies that a ViewModel notifies listeners
  static void verifyNotifiesListeners<T extends ChangeNotifier>(
    T viewModel,
    VoidCallback action,
  ) {
    bool notified = false;
    viewModel.addListener(() {
      notified = true;
    });

    action();

    expect(notified, isTrue, reason: 'ViewModel should notify listeners');
  }

  /// Verifies that a ViewModel does not notify listeners
  static void verifyDoesNotNotifyListeners<T extends ChangeNotifier>(
    T viewModel,
    VoidCallback action,
  ) {
    bool notified = false;
    viewModel.addListener(() {
      notified = true;
    });

    action();

    expect(notified, isFalse, reason: 'ViewModel should not notify listeners');
  }

  /// Creates a mock delay for testing async operations
  static Future<void> mockDelay([
    Duration duration = const Duration(milliseconds: 100),
  ]) {
    return Future.delayed(duration);
  }

  /// Asserts that two lists contain the same elements in the same order
  static void assertListEquals<T>(List<T> expected, List<T> actual) {
    expect(
      actual.length,
      equals(expected.length),
      reason: 'Lists should have the same length',
    );
    for (int i = 0; i < expected.length; i++) {
      expect(
        actual[i],
        equals(expected[i]),
        reason: 'Element at index $i should match',
      );
    }
  }

  /// Asserts that a list is sorted by a given comparison function
  static void assertListIsSorted<T>(List<T> list, int Function(T, T) compare) {
    for (int i = 0; i < list.length - 1; i++) {
      expect(
        compare(list[i], list[i + 1]),
        lessThanOrEqualTo(0),
        reason:
            'List should be sorted, but elements at $i and ${i + 1} are not in order',
      );
    }
  }

  /// Asserts that a list is sorted in descending order by a given comparison function
  static void assertListIsSortedDescending<T>(
    List<T> list,
    int Function(T, T) compare,
  ) {
    for (int i = 0; i < list.length - 1; i++) {
      expect(
        compare(list[i], list[i + 1]),
        greaterThanOrEqualTo(0),
        reason:
            'List should be sorted in descending order, but elements at $i and ${i + 1} are not in order',
      );
    }
  }
}

/// Custom matchers for testing
class CustomMatchers {
  /// Matches a Result that is successful
  static Matcher isSuccessResult<T>() {
    return predicate<Result<T>>(
      (result) => result.isSuccess,
      'is a successful Result',
    );
  }

  /// Matches a Result that is a failure
  static Matcher isFailureResult<T>() {
    return predicate<Result<T>>(
      (result) => result.isFailure,
      'is a failed Result',
    );
  }

  /// Matches a Result with specific data
  static Matcher hasResultData<T>(T expectedData) {
    return predicate<Result<T>>(
      (result) => result.isSuccess && result.data == expectedData,
      'has Result data: $expectedData',
    );
  }

  /// Matches a Result with specific failure
  static Matcher hasResultFailure<T>(failures.Failure expectedFailure) {
    return predicate<Result<T>>(
      (result) => result.isFailure && result.failure == expectedFailure,
      'has Result failure: $expectedFailure',
    );
  }
}
