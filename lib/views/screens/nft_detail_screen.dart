import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/nft_viewmodel.dart';
import '../widgets/error_widget.dart' as custom_error;
import 'send_nft_dialog.dart';

/// NFT detail screen
class NftDetailScreen extends StatefulWidget {
  const NftDetailScreen({super.key});

  @override
  State<NftDetailScreen> createState() => _NftDetailScreenState();
}

class _NftDetailScreenState extends State<NftDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Details'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        actions: [
          Consumer<NftViewModel>(
            builder: (context, viewModel, child) {
              final nft = viewModel.selectedNft;
              if (nft == null) return const SizedBox.shrink();

              return PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'hide':
                      viewModel.updateNftHiddenStatus(
                        nftId: nft.id,
                        isHidden: !nft.isHidden,
                      );
                      break;
                    case 'report':
                      _showReportDialog(context, nft, viewModel);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'hide',
                    child: Row(
                      children: [
                        Icon(
                          nft.isHidden ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(nft.isHidden ? 'Unhide' : 'Hide'),
                      ],
                    ),
                  ),
                  if (nft.isScam)
                    const PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(Icons.report, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Report', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<NftViewModel>(
        builder: (context, viewModel, child) {
          final nft = viewModel.selectedNft;

          if (nft == null) {
            return const custom_error.ErrorWidget(
              message: 'No NFT selected',
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNftImage(nft),
                _buildNftInfo(nft),
                _buildAttributes(nft),
                _buildActions(nft, viewModel),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the NFT image section
  Widget _buildNftImage(nft) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              nft.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surfaceVariant,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
            if (nft.isScam)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'SUSPICIOUS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the NFT information section
  Widget _buildNftInfo(nft) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nft.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nft.collection,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            nft.description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Token ID', nft.tokenId.toString()),
          _buildInfoRow('Asset ID', nft.assetId.toString()),
          _buildInfoRow('Creator', _formatAddress(nft.creator)),
          _buildInfoRow('Owner', _formatAddress(nft.owner)),
          _buildInfoRow('Mint Price', nft.formattedMintPrice),
          _buildInfoRow('Mint Date', nft.formattedMintDate),
          if (nft.isScam && nft.scamReason != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Warning: ${nft.scamReason}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds an info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the attributes section
  Widget _buildAttributes(nft) {
    if (nft.attributes == null || nft.attributes!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attributes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: nft.attributes!.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Builds the actions section
  Widget _buildActions(nft, NftViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showSendDialog(context, nft, viewModel),
              icon: const Icon(Icons.send),
              label: const Text('Send NFT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the send NFT dialog
  void _showSendDialog(BuildContext context, nft, NftViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => SendNftDialog(
        nft: nft,
        onSend: (toAddress, note) async {
          final success = await viewModel.sendNftToAddress(
            nftId: nft.id,
            toAddress: toAddress,
            note: note,
          );

          if (success && mounted) {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Close detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('NFT sent successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.error ?? 'Failed to send NFT'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  /// Shows the report dialog
  void _showReportDialog(BuildContext context, nft, NftViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report NFT'),
        content: const Text(
          'Are you sure you want to report this NFT as suspicious? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('NFT reported successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  /// Formats an address for display
  String _formatAddress(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }
}
