/// App enums for type safety
enum AppPage { wallet, defi, ecosystem, news, tokens }

/// Extension methods for AppPage enum
extension AppPageExtension on AppPage {
  /// Returns the index of the page for bottom navigation
  int get index {
    switch (this) {
      case AppPage.wallet:
        return 0;
      case AppPage.defi:
        return 1;
      case AppPage.ecosystem:
        return 2;
      case AppPage.news:
        return 3;
      case AppPage.tokens:
        return 4;
    }
  }

  /// Returns the title of the page
  String get title {
    switch (this) {
      case AppPage.wallet:
        return 'Wallet';
      case AppPage.defi:
        return 'DeFi';
      case AppPage.ecosystem:
        return 'Ecosystem';
      case AppPage.news:
        return 'News';
      case AppPage.tokens:
        return 'Tokens';
    }
  }

  /// Returns the route name of the page
  String get routeName {
    switch (this) {
      case AppPage.wallet:
        return '/wallet';
      case AppPage.defi:
        return '/defi';
      case AppPage.ecosystem:
        return '/ecosystem';
      case AppPage.news:
        return '/news';
      case AppPage.tokens:
        return '/tokens';
    }
  }

  /// Returns the icon data for the page
  String get iconName {
    switch (this) {
      case AppPage.wallet:
        return 'account_balance_wallet';
      case AppPage.defi:
        return 'trending_up';
      case AppPage.ecosystem:
        return 'apps';
      case AppPage.news:
        return 'newspaper';
      case AppPage.tokens:
        return 'token';
    }
  }
}
