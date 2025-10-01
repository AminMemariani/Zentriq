import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../viewmodels/token_viewmodel.dart';
import '../../domain/entities/token.dart';
import '../widgets/base_screen.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../../core/design/design_system.dart';

/// Tokens screen for token list and top performers with MVVM pattern
class TokensScreen extends StatefulWidget {
  const TokensScreen({super.key});

  @override
  State<TokensScreen> createState() => _TokensScreenState();
}

class _TokensScreenState extends State<TokensScreen> {
  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Top Performers', 'Market Cap', 'Volume'];

  @override
  void initState() {
    super.initState();
    // Load token data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TokenViewModel>().loadAllTokens();
      context.read<TokenViewModel>().loadTopPerformers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Tokens',
      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 20),
          onPressed: () {
            context.read<TokenViewModel>().refreshTokens();
          },
        ),
      ],
      body: Consumer<TokenViewModel>(
        builder: (context, viewModel, child) {
          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, viewModel),
            tablet: _buildTabletLayout(context, viewModel),
            desktop: _buildDesktopLayout(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, TokenViewModel viewModel) {
    return Column(
      children: [
        _buildPortfolioOverview(context, viewModel),
        _buildTabBar(context),
        Expanded(child: _buildTokenList(context, viewModel)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, TokenViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPortfolioOverview(context, viewModel),
              const SizedBox(height: 16),
              _buildTabBar(context),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: _buildTokenList(context, viewModel)),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, TokenViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPortfolioOverview(context, viewModel),
              const SizedBox(height: 16),
              _buildTabBar(context),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 3, child: _buildTokenList(context, viewModel)),
      ],
    );
  }

  Widget _buildPortfolioOverview(
    BuildContext context,
    TokenViewModel viewModel,
  ) {
    return DesignSystem.createCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: DesignSystem.iconSizeL,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: DesignSystem.spacingM),
              Text(
                'Portfolio Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingL),
          Row(
            children: [
              Expanded(
                child: DesignSystem.createStatCard(
                  context,
                  icon: FontAwesomeIcons.wallet,
                  title: 'Total Value',
                  value:
                      '\$${viewModel.getPortfolioValue().toStringAsFixed(2)}',
                ),
              ),
              const SizedBox(width: DesignSystem.spacingM),
              Expanded(
                child: DesignSystem.createStatCard(
                  context,
                  icon: FontAwesomeIcons.chartLine,
                  title: '24h Change',
                  value:
                      '${viewModel.getPortfolioChangePercentage() >= 0 ? '+' : ''}${viewModel.getPortfolioChangePercentage().toStringAsFixed(2)}%',
                  isPositive: viewModel.getPortfolioChangePercentage() >= 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesignSystem.cardSpacing),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.map((tab) {
            final isSelected = _selectedTab == tab;
            final icon = _getTabIcon(tab);
            return Padding(
              padding: const EdgeInsets.only(right: DesignSystem.spacingM),
              child: DesignSystem.createChip(
                context,
                label: tab,
                icon: icon,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedTab = tab;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getTabIcon(String tab) {
    switch (tab) {
      case 'All':
        return FontAwesomeIcons.list;
      case 'Top Performers':
        return FontAwesomeIcons.trophy;
      case 'Gainers':
        return FontAwesomeIcons.arrowTrendUp;
      case 'Losers':
        return FontAwesomeIcons.arrowTrendDown;
      default:
        return FontAwesomeIcons.coins;
    }
  }

  Widget _buildTokenList(BuildContext context, TokenViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(DesignSystem.cardSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DesignSystem.createSectionHeader(context, title: _getListTitle()),
          const SizedBox(height: DesignSystem.spacingM),
          Expanded(child: _buildTokenListView(context, viewModel)),
        ],
      ),
    );
  }

  String _getListTitle() {
    switch (_selectedTab) {
      case 'Top Performers':
        return 'Top Performers (24h)';
      case 'Market Cap':
        return 'Tokens by Market Cap';
      case 'Volume':
        return 'Tokens by Volume';
      default:
        return 'All Tokens';
    }
  }

  Widget _buildTokenListView(BuildContext context, TokenViewModel viewModel) {
    if (_isLoading(viewModel)) {
      return const LoadingWidget(message: 'Loading tokens...');
    }

    if (_hasError(viewModel)) {
      return custom.ErrorWidget(
        message: _getErrorMessage(viewModel),
        onRetry: () => _refreshData(viewModel),
      );
    }

    final tokens = _getTokensForTab(viewModel);
    if (tokens.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return _buildTokenCard(context, token);
      },
    );
  }

  bool _isLoading(TokenViewModel viewModel) {
    switch (_selectedTab) {
      case 'Top Performers':
        return viewModel.isLoadingTopPerformers;
      default:
        return viewModel.isLoadingAllTokens;
    }
  }

  bool _hasError(TokenViewModel viewModel) {
    switch (_selectedTab) {
      case 'Top Performers':
        return viewModel.hasTopPerformersError;
      default:
        return viewModel.hasAllTokensError;
    }
  }

  String _getErrorMessage(TokenViewModel viewModel) {
    switch (_selectedTab) {
      case 'Top Performers':
        return viewModel.topPerformersErrorMessage ?? 'Unknown error';
      default:
        return viewModel.allTokensErrorMessage ?? 'Unknown error';
    }
  }

  void _refreshData(TokenViewModel viewModel) {
    switch (_selectedTab) {
      case 'Top Performers':
        viewModel.loadTopPerformers();
        break;
      default:
        viewModel.loadAllTokens();
        break;
    }
  }

  List<Token> _getTokensForTab(TokenViewModel viewModel) {
    switch (_selectedTab) {
      case 'Top Performers':
        return viewModel.topPerformers;
      case 'Market Cap':
        return viewModel.getTokensByMarketCap();
      case 'Volume':
        return viewModel.getTokensByVolume();
      default:
        return viewModel.allTokens;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.token,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No tokens found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Token data will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenCard(BuildContext context, Token token) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            token.symbol.substring(0, 1),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              token.symbol,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (token.rank != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${token.rank}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(token.name),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              token.formattedPrice,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  token.isPositiveChange
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 12,
                  color: token.isPositiveChange
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 2),
                Text(
                  token.formattedPriceChangePercentage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: token.isPositiveChange
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          _showTokenDetails(context, token);
        },
      ),
    );
  }

  void _showTokenDetails(BuildContext context, Token token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                token.symbol.substring(0, 1),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(token.name),
                  Text(
                    token.symbol,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Price', token.formattedPrice),
            _buildDetailRow('24h Change', token.formattedPriceChangePercentage),
            _buildDetailRow('Market Cap', token.formattedMarketCap),
            _buildDetailRow('Volume (24h)', token.formattedVolume),
            if (token.circulatingSupply != null)
              _buildDetailRow(
                'Circulating Supply',
                token.formattedCirculatingSupply,
              ),
            if (token.totalSupply != null)
              _buildDetailRow('Total Supply', token.formattedTotalSupply),
            _buildDetailRow('Last Updated', token.formattedLastUpdated),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
