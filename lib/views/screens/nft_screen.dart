import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/nft_viewmodel.dart';
import '../../domain/entities/nft.dart';
import '../widgets/base_screen.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom_error;
import 'nft_detail_screen.dart';

/// NFT Collectibles screen
class NftScreen extends StatefulWidget {
  const NftScreen({super.key});

  @override
  State<NftScreen> createState() => _NftScreenState();
}

class _NftScreenState extends State<NftScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NftViewModel>().loadNfts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'NFT Collectibles',
      body: Consumer<NftViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.allNfts.isEmpty) {
            return const LoadingWidget();
          }

          if (viewModel.error != null && viewModel.allNfts.isEmpty) {
            return custom_error.ErrorWidget(
              message: viewModel.error!,
              onRetry: () => viewModel.refresh(),
            );
          }

          return Column(
            children: [
              _buildTabSelector(viewModel),
              const SizedBox(height: 16),
              _buildStatsRow(viewModel),
              const SizedBox(height: 16),
              Expanded(
                child: _buildNftGrid(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds the tab selector
  Widget _buildTabSelector(NftViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              'All NFTs',
              NftTab.all,
              viewModel.currentTab == NftTab.all,
              () => viewModel.changeTab(NftTab.all),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              'Hidden/Filtered',
              NftTab.suspicious,
              viewModel.currentTab == NftTab.suspicious,
              () => viewModel.changeTab(NftTab.suspicious),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a tab button
  Widget _buildTabButton(
    String label,
    NftTab tab,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Builds the stats row
  Widget _buildStatsRow(NftViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard(
            'Total',
            viewModel.totalNftCount.toString(),
            AppColors.primary,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Safe',
            viewModel.safeNftCount.toString(),
            Colors.green,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Filtered',
            viewModel.suspiciousNftCount.toString(),
            Colors.orange,
          ),
        ],
      ),
    );
  }

  /// Builds a stat card
  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the NFT grid
  Widget _buildNftGrid(NftViewModel viewModel) {
    final nfts = viewModel.currentTabNfts;

    if (nfts.isEmpty) {
      return _buildEmptyState(viewModel.currentTab);
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: nfts.length,
        itemBuilder: (context, index) {
          final nft = nfts[index];
          return _buildNftCard(nft, viewModel);
        },
      ),
    );
  }

  /// Builds an NFT card
  Widget _buildNftCard(Nft nft, NftViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        viewModel.selectNft(nft);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NftDetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: nft.isScam
                ? Colors.red.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      nft.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppColors.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                  if (nft.isScam)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'SCAM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nft.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nft.collection,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nft.formattedMintPrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        if (nft.isHidden)
                          const Icon(
                            Icons.visibility_off,
                            size: 16,
                            color: AppColors.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds empty state
  Widget _buildEmptyState(NftTab tab) {
    String message;
    IconData icon;

    switch (tab) {
      case NftTab.all:
        message = 'No NFTs found';
        icon = Icons.image_not_supported;
        break;
      case NftTab.suspicious:
        message = 'No suspicious NFTs found';
        icon = Icons.security;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
