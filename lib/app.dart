import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_theme.dart';
import 'core/constants/app_enums.dart';
import 'core/constants/navigation_constants.dart';
import 'viewmodels/main_viewmodel.dart';
import 'viewmodels/user_viewmodel.dart';
import 'viewmodels/wallet_viewmodel.dart';
import 'viewmodels/token_viewmodel.dart';
import 'viewmodels/ecosystem_viewmodel.dart';
import 'viewmodels/news_viewmodel.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/wallet_repository_impl.dart';
import 'data/repositories/token_repository_impl.dart';
import 'data/repositories/project_repository_impl.dart';
import 'data/repositories/news_repository_impl.dart';
import 'data/services/algorand_blockchain_service.dart';
import 'data/services/token_pricing_service.dart';
import 'data/services/news_service.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/get_wallet.dart';
import 'domain/usecases/get_transaction_history.dart';
import 'domain/usecases/send_transaction.dart';
import 'domain/usecases/get_all_tokens.dart';
import 'domain/usecases/get_top_performers.dart';
import 'domain/usecases/get_all_projects.dart';
import 'domain/usecases/get_featured_projects.dart';
import 'domain/usecases/get_latest_news.dart';
import 'domain/usecases/get_trending_news.dart';
import 'views/screens/wallet_screen.dart';
import 'views/screens/defi_screen.dart';
import 'views/screens/ecosystem_screen.dart';
import 'views/screens/news_screen.dart';
import 'views/screens/tokens_screen.dart';
import 'views/widgets/bottom_navigation_bar.dart';

/// Main application widget with MVVM architecture and navigation
class ZentriqApp extends StatelessWidget {
  const ZentriqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Main ViewModel for navigation state
        ChangeNotifierProvider<MainViewModel>(create: (_) => MainViewModel()),

        // Repository providers
        Provider<UserRepositoryImpl>(create: (_) => const UserRepositoryImpl()),
        Provider<WalletRepositoryImpl>(
          create: (_) => const WalletRepositoryImpl(),
        ),
        Provider<TokenRepositoryImpl>(
          create: (_) => const TokenRepositoryImpl(),
        ),
        Provider<ProjectRepositoryImpl>(
          create: (_) => const ProjectRepositoryImpl(),
        ),
        Provider<NewsRepositoryImpl>(create: (_) => const NewsRepositoryImpl()),

        // Service providers
        Provider<AlgorandBlockchainService>(
          create: (_) => AlgorandBlockchainService(
            // You can configure different RPC nodes here
            baseUrl: 'https://mainnet-api.algonode.cloud',
            indexerUrl: 'https://mainnet-idx.algonode.cloud',
            // apiKey: 'your-api-key-here', // Optional API key
          ),
        ),
        Provider<TokenPricingService>(
          create: (_) => TokenPricingService(
            // coinGeckoApiKey: 'your-coin-gecko-api-key', // Optional
            // coinMarketCapApiKey: 'your-coinmarketcap-api-key', // Optional
          ),
        ),
        Provider<NewsService>(
          create: (_) => NewsService(
            // newsApiKey: 'your-news-api-key', // Optional
            // cryptoCompareApiKey: 'your-cryptocompare-api-key', // Optional
          ),
        ),

        // Use case providers
        ProxyProvider<UserRepositoryImpl, GetCurrentUser>(
          update: (_, repository, __) => GetCurrentUser(repository),
        ),
        ProxyProvider<WalletRepositoryImpl, GetWallet>(
          update: (_, repository, __) => GetWallet(repository),
        ),
        ProxyProvider<WalletRepositoryImpl, GetTransactionHistory>(
          update: (_, repository, __) => GetTransactionHistory(repository),
        ),
        ProxyProvider<WalletRepositoryImpl, SendTransaction>(
          update: (_, repository, __) => SendTransaction(repository),
        ),
        ProxyProvider<TokenRepositoryImpl, GetAllTokens>(
          update: (_, repository, __) => GetAllTokens(repository),
        ),
        ProxyProvider<TokenRepositoryImpl, GetTopPerformers>(
          update: (_, repository, __) => GetTopPerformers(repository),
        ),
        ProxyProvider<ProjectRepositoryImpl, GetAllProjects>(
          update: (_, repository, __) => GetAllProjects(repository),
        ),
        ProxyProvider<ProjectRepositoryImpl, GetFeaturedProjects>(
          update: (_, repository, __) => GetFeaturedProjects(repository),
        ),
        ProxyProvider<NewsRepositoryImpl, GetLatestNews>(
          update: (_, repository, __) => GetLatestNews(repository),
        ),
        ProxyProvider<NewsRepositoryImpl, GetTrendingNews>(
          update: (_, repository, __) => GetTrendingNews(repository),
        ),

        // ViewModel providers
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => UserViewModel(context.read<GetCurrentUser>()),
        ),
        ChangeNotifierProvider<WalletViewModel>(
          create: (context) => WalletViewModel(
            context.read<GetWallet>(),
            context.read<GetTransactionHistory>(),
            context.read<SendTransaction>(),
          ),
        ),
        ChangeNotifierProvider<TokenViewModel>(
          create: (context) => TokenViewModel(
            context.read<GetAllTokens>(),
            context.read<GetTopPerformers>(),
          ),
        ),
        ChangeNotifierProvider<EcosystemViewModel>(
          create: (context) => EcosystemViewModel(
            context.read<GetAllProjects>(),
            context.read<GetFeaturedProjects>(),
          ),
        ),
        ChangeNotifierProvider<NewsViewModel>(
          create: (context) => NewsViewModel(
            context.read<GetLatestNews>(),
            context.read<GetTrendingNews>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Adaptive theming
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Home screen with navigation
        home: const MainNavigationScreen(),

        // Route generation
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  /// Generates routes for the application
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationConstants.home:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case NavigationConstants.wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case NavigationConstants.defi:
        return MaterialPageRoute(builder: (_) => const DeFiScreen());
      case NavigationConstants.ecosystem:
        return MaterialPageRoute(builder: (_) => const EcosystemScreen());
      case NavigationConstants.news:
        return MaterialPageRoute(builder: (_) => const NewsScreen());
      case NavigationConstants.tokens:
        return MaterialPageRoute(builder: (_) => const TokensScreen());
      default:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
    }
  }
}

/// Main navigation screen that handles bottom navigation
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: _buildCurrentPage(viewModel.currentPage),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }

  /// Builds the current page based on the selected navigation item
  Widget _buildCurrentPage(AppPage page) {
    switch (page) {
      case AppPage.wallet:
        return const WalletScreen();
      case AppPage.defi:
        return const DeFiScreen();
      case AppPage.ecosystem:
        return const EcosystemScreen();
      case AppPage.news:
        return const NewsScreen();
      case AppPage.tokens:
        return const TokensScreen();
    }
  }
}
