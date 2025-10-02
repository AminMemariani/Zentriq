import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../viewmodels/wallet_viewmodel.dart';
import '../widgets/base_screen.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../../core/design/design_system.dart';

/// Wallet screen for core wallet functions with MVVM pattern
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    // Load wallet data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletViewModel>().loadWallet();
      context.read<WalletViewModel>().loadTransactionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Wallet',
      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 20),
          onPressed: () {
            context.read<WalletViewModel>().refreshWallet();
          },
        ),
      ],
      body: Consumer<WalletViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoadingWallet && viewModel.wallet == null) {
            return const LoadingWidget(message: 'Loading wallet...');
          }

          if (viewModel.hasWalletError && viewModel.wallet == null) {
            return custom.ErrorWidget(
              message: viewModel.walletErrorMessage!,
              onRetry: () => viewModel.loadWallet(),
            );
          }

          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, viewModel),
            tablet: _buildTabletLayout(context, viewModel),
            desktop: _buildDesktopLayout(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WalletViewModel viewModel) {
    return SingleChildScrollView(
      child: ResponsivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(context, viewModel),
            const SizedBox(height: 16),
            _buildActionButtons(context, viewModel),
            const SizedBox(height: 24),
            _buildTransactionHistory(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WalletViewModel viewModel) {
    return SingleChildScrollView(
      child: ResponsivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildBalanceCard(context, viewModel),
                      const SizedBox(height: 16),
                      _buildActionButtons(context, viewModel),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: _buildTransactionHistory(context, viewModel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WalletViewModel viewModel) {
    return SingleChildScrollView(
      child: ResponsivePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildBalanceCard(context, viewModel),
                      const SizedBox(height: 16),
                      _buildActionButtons(context, viewModel),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _buildTransactionHistory(context, viewModel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, WalletViewModel viewModel) {
    return DesignSystem.createCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.wallet,
                size: DesignSystem.iconSizeL,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: DesignSystem.spacingM),
              Expanded(
                child: Text(
                  'Total Balance',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (viewModel.isLoadingWallet)
                SizedBox(
                  width: DesignSystem.iconSizeM,
                  height: DesignSystem.iconSizeM,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingL),
          Text(
            viewModel.wallet?.formattedBalance ?? '0.00 ALGO',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            viewModel.wallet?.formattedBalanceUSD ?? '\$0.00 USD',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingL),
          _buildWalletAddress(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildWalletAddress(BuildContext context, WalletViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DesignSystem.radiusM),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.addressCard,
            size: DesignSystem.iconSizeM,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: Text(
              viewModel.getFormattedWalletAddress() ?? 'Loading...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
            ),
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.copy, size: DesignSystem.iconSizeM),
            onPressed: () {
              // TODO: Copy to clipboard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address copied to clipboard')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WalletViewModel viewModel) {
    return DesignSystem.createResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 3,
      desktopColumns: 3,
      children: [
        _buildActionButton(
          context,
          'Send',
          FontAwesomeIcons.paperPlane,
          Theme.of(context).colorScheme.primary,
          () => _showSendDialog(context, viewModel),
        ),
        _buildActionButton(
          context,
          'Receive',
          FontAwesomeIcons.qrcode,
          Theme.of(context).colorScheme.secondary,
          () => _showReceiveDialog(context, viewModel),
        ),
        _buildActionButton(
          context,
          'History',
          FontAwesomeIcons.clockRotateLeft,
          Theme.of(context).colorScheme.tertiary,
          () => _showTransactionHistory(context, viewModel),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return DesignSystem.createCompactCard(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: DesignSystem.iconSizeXL / 2,
            backgroundColor: color.withOpacity(0.1),
            child: FaIcon(icon, color: color, size: DesignSystem.iconSizeL),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(
    BuildContext context,
    WalletViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            if (viewModel.isLoadingTransactions)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.hasTransactionsError)
          custom.ErrorWidget(
            message: viewModel.transactionsErrorMessage!,
            onRetry: () => viewModel.loadTransactionHistory(),
            icon: Icons.error_outline,
          )
        else if (viewModel.transactions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your transaction history will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: viewModel.getRecentTransactions().map((transaction) {
                return _buildTransactionTile(context, transaction);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionTile(BuildContext context, transaction) {
    final isSend = transaction.type.name == 'send';
    final color = isSend
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    final icon = isSend ? Icons.send : Icons.call_received;
    final amountPrefix = isSend ? '-' : '+';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        transaction.note ?? 'Transaction',
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(transaction.formattedTimestamp),
      trailing: Text(
        '$amountPrefix${transaction.formattedAmount}',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        // TODO: Show transaction details
      },
    );
  }

  void _showSendDialog(BuildContext context, WalletViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send ALGO'),
        content: const Text('Send functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReceiveDialog(BuildContext context, WalletViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receive ALGO'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your wallet address:'),
            const SizedBox(height: 8),
            SelectableText(
              viewModel.getWalletAddress() ?? 'Loading...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            const Text('QR Code functionality will be implemented here.'),
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

  void _showTransactionHistory(
    BuildContext context,
    WalletViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: viewModel.transactions.length,
            itemBuilder: (context, index) {
              final transaction = viewModel.transactions[index];
              return _buildTransactionTile(context, transaction);
            },
          ),
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
}
