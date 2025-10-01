import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import '../widgets/responsive_layout.dart';

/// DeFi screen for staking, yield farming, and DeFi integrations
class DeFiScreen extends StatefulWidget {
  const DeFiScreen({super.key});

  @override
  State<DeFiScreen> createState() => _DeFiScreenState();
}

class _DeFiScreenState extends State<DeFiScreen> {
  String _selectedTab = 'Staking';
  final List<String> _tabs = [
    'Staking',
    'Yield Farming',
    'Protocols',
    'Portfolio',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'DeFi',
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildDeFiOverview(context),
        _buildTabBar(context),
        Expanded(child: _buildTabContent(context)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildDeFiOverview(context),
              const SizedBox(height: 16),
              _buildTabBar(context),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: _buildTabContent(context)),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildDeFiOverview(context),
              const SizedBox(height: 16),
              _buildTabBar(context),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 3, child: _buildTabContent(context)),
      ],
    );
  }

  Widget _buildDeFiOverview(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DeFi Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDeFiStat(
                    context,
                    'Total Staked',
                    '1,250.75 ALGO',
                    Icons.account_balance,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDeFiStat(
                    context,
                    'Total APY',
                    '8.45%',
                    Icons.trending_up,
                    isPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDeFiStat(
                    context,
                    'Active Pools',
                    '3',
                    Icons.water_drop,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDeFiStat(
                    context,
                    'Total Rewards',
                    '45.23 ALGO',
                    Icons.emoji_events,
                    isPositive: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeFiStat(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isPositive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _tabs.map((tab) {
            final isSelected = _selectedTab == tab;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(tab),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTab = tab;
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                checkmarkColor: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getTabTitle(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Expanded(child: _buildTabContentBody(context)),
        ],
      ),
    );
  }

  String _getTabTitle() {
    switch (_selectedTab) {
      case 'Staking':
        return 'Staking Options';
      case 'Yield Farming':
        return 'Yield Farming Pools';
      case 'Protocols':
        return 'DeFi Protocols';
      case 'Portfolio':
        return 'Your DeFi Portfolio';
      default:
        return _selectedTab;
    }
  }

  Widget _buildTabContentBody(BuildContext context) {
    switch (_selectedTab) {
      case 'Staking':
        return _buildStakingContent(context);
      case 'Yield Farming':
        return _buildYieldFarmingContent(context);
      case 'Protocols':
        return _buildProtocolsContent(context);
      case 'Portfolio':
        return _buildPortfolioContent(context);
      default:
        return const Center(child: Text('Coming soon...'));
    }
  }

  Widget _buildStakingContent(BuildContext context) {
    return ListView(
      children: [
        _buildStakingCard(
          context,
          'Algorand Governance',
          'Participate in Algorand governance and earn rewards',
          '5.2% APY',
          '1,000 ALGO staked',
          Icons.account_balance,
          isActive: true,
        ),
        const SizedBox(height: 12),
        _buildStakingCard(
          context,
          'Yieldly Staking',
          'Stake YLDY tokens for additional rewards',
          '12.5% APY',
          'Not staked',
          Icons.auto_awesome,
          isActive: false,
        ),
        const SizedBox(height: 12),
        _buildStakingCard(
          context,
          'Folks Finance',
          'Lend your ALGO and earn interest',
          '3.8% APY',
          'Not staked',
          Icons.account_balance_wallet,
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildYieldFarmingContent(BuildContext context) {
    return ListView(
      children: [
        _buildYieldFarmCard(
          context,
          'ALGO/YLDY Pool',
          'Farm YLDY tokens by providing liquidity',
          '15.2% APY',
          '250 ALGO + 12,500 YLDY',
          Icons.agriculture,
          isActive: true,
        ),
        const SizedBox(height: 12),
        _buildYieldFarmCard(
          context,
          'USDC/ALGO Pool',
          'Farm stable yields with low risk',
          '6.8% APY',
          'Not farming',
          Icons.agriculture,
          isActive: false,
        ),
        const SizedBox(height: 12),
        _buildYieldFarmCard(
          context,
          'OPUL/ALGO Pool',
          'Farm OPUL rewards for music NFTs',
          '22.1% APY',
          'Not farming',
          Icons.agriculture,
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildProtocolsContent(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildProtocolCard(
          context,
          'Tinyman',
          'DEX',
          'Swap tokens',
          Icons.swap_horiz,
          isConnected: true,
        ),
        _buildProtocolCard(
          context,
          'PactFi',
          'DEX',
          'Advanced trading',
          Icons.swap_horiz,
          isConnected: false,
        ),
        _buildProtocolCard(
          context,
          'Folks Finance',
          'Lending',
          'Borrow & lend',
          Icons.account_balance,
          isConnected: true,
        ),
        _buildProtocolCard(
          context,
          'Algofi',
          'Lending',
          'DeFi lending',
          Icons.account_balance,
          isConnected: false,
        ),
        _buildProtocolCard(
          context,
          'Yieldly',
          'Staking',
          'No-loss lottery',
          Icons.auto_awesome,
          isConnected: true,
        ),
        _buildProtocolCard(
          context,
          'GARD',
          'Stablecoin',
          'Algorithmic stablecoin',
          Icons.attach_money,
          isConnected: false,
        ),
      ],
    );
  }

  Widget _buildPortfolioContent(BuildContext context) {
    return ListView(
      children: [
        _buildPortfolioCard(
          context,
          'Governance Staking',
          '1,000 ALGO',
          '5.2% APY',
          '52.00 ALGO',
          Icons.account_balance,
        ),
        const SizedBox(height: 12),
        _buildPortfolioCard(
          context,
          'ALGO/YLDY Pool',
          '250 ALGO + 12,500 YLDY',
          '15.2% APY',
          '38.00 ALGO',
          Icons.agriculture,
        ),
        const SizedBox(height: 12),
        _buildPortfolioCard(
          context,
          'Folks Finance Lending',
          '500 ALGO',
          '3.8% APY',
          '19.00 ALGO',
          Icons.account_balance_wallet,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total DeFi Value',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '1,750.75 ALGO',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Rewards: 109.00 ALGO',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStakingCard(
    BuildContext context,
    String title,
    String description,
    String apy,
    String status,
    IconData icon, {
    required bool isActive,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              apy,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text('APY', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        onTap: () {
          _showStakingDetails(
            context,
            title,
            description,
            apy,
            status,
            isActive,
          );
        },
      ),
    );
  }

  Widget _buildYieldFarmCard(
    BuildContext context,
    String title,
    String description,
    String apy,
    String status,
    IconData icon, {
    required bool isActive,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              apy,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 2),
            Text('APY', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        onTap: () {
          _showYieldFarmDetails(
            context,
            title,
            description,
            apy,
            status,
            isActive,
          );
        },
      ),
    );
  }

  Widget _buildProtocolCard(
    BuildContext context,
    String name,
    String type,
    String description,
    IconData icon, {
    required bool isConnected,
  }) {
    return Card(
      child: InkWell(
        onTap: () {
          _showProtocolDetails(context, name, type, description, isConnected);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  if (isConnected)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(
    BuildContext context,
    String title,
    String amount,
    String apy,
    String rewards,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(amount),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              apy,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Rewards: $rewards',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        onTap: () {
          _showPortfolioDetails(context, title, amount, apy, rewards);
        },
      ),
    );
  }

  void _showStakingDetails(
    BuildContext context,
    String title,
    String description,
    String apy,
    String status,
    bool isActive,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 16),
            _buildDetailRow('APY', apy),
            _buildDetailRow('Status', status),
            _buildDetailRow('Active', isActive ? 'Yes' : 'No'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (!isActive)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement staking action
              },
              child: const Text('Stake'),
            ),
        ],
      ),
    );
  }

  void _showYieldFarmDetails(
    BuildContext context,
    String title,
    String description,
    String apy,
    String status,
    bool isActive,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 16),
            _buildDetailRow('APY', apy),
            _buildDetailRow('Status', status),
            _buildDetailRow('Active', isActive ? 'Yes' : 'No'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (!isActive)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement yield farming action
              },
              child: const Text('Start Farming'),
            ),
        ],
      ),
    );
  }

  void _showProtocolDetails(
    BuildContext context,
    String name,
    String type,
    String description,
    bool isConnected,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 16),
            _buildDetailRow('Type', type),
            _buildDetailRow(
              'Status',
              isConnected ? 'Connected' : 'Not Connected',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (!isConnected)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement protocol connection
              },
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }

  void _showPortfolioDetails(
    BuildContext context,
    String title,
    String amount,
    String apy,
    String rewards,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount', amount),
            _buildDetailRow('APY', apy),
            _buildDetailRow('Total Rewards', rewards),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement claim rewards action
            },
            child: const Text('Claim Rewards'),
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
