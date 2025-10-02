import 'package:flutter/foundation.dart';
import '../domain/entities/nft.dart';
import '../domain/usecases/get_all_nfts.dart';
import '../domain/usecases/send_nft.dart';
import '../domain/usecases/update_nft_visibility.dart';
import '../core/utils/result.dart';
import '../core/utils/use_case.dart';

/// ViewModel for NFT management
class NftViewModel extends ChangeNotifier {
  NftViewModel({
    required this.getAllNfts,
    required this.sendNft,
    required this.updateNftVisibility,
  });

  final GetAllNfts getAllNfts;
  final SendNft sendNft;
  final UpdateNftVisibility updateNftVisibility;

  // State
  List<Nft> _allNfts = [];
  List<Nft> _safeNfts = [];
  List<Nft> _suspiciousNfts = [];
  bool _isLoading = false;
  String? _error;
  NftTab _currentTab = NftTab.all;
  Nft? _selectedNft;

  // Getters
  List<Nft> get allNfts => _allNfts;
  List<Nft> get safeNfts => _safeNfts;
  List<Nft> get suspiciousNfts => _suspiciousNfts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  NftTab get currentTab => _currentTab;
  Nft? get selectedNft => _selectedNft;

  /// Gets NFTs based on current tab
  List<Nft> get currentTabNfts {
    switch (_currentTab) {
      case NftTab.all:
        return _safeNfts;
      case NftTab.suspicious:
        return _suspiciousNfts;
    }
  }

  /// Gets total NFT count
  int get totalNftCount => _allNfts.length;

  /// Gets safe NFT count
  int get safeNftCount => _safeNfts.length;

  /// Gets suspicious NFT count
  int get suspiciousNftCount => _suspiciousNfts.length;

  /// Loads all NFTs
  Future<void> loadNfts() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await getAllNfts(const NoParams());
      
      if (result.isSuccess) {
        _allNfts = result.data!;
        _categorizeNfts();
      } else {
        _setError(result.failure?.message ?? 'Failed to load NFTs');
      }
    } catch (e) {
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Sends an NFT to another address
  Future<bool> sendNftToAddress({
    required String nftId,
    required String toAddress,
    String? note,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await sendNft(SendNftParams(
        nftId: nftId,
        toAddress: toAddress,
        note: note,
      ));

      if (result.isSuccess) {
        // Remove the sent NFT from the list
        _allNfts.removeWhere((nft) => nft.id == nftId);
        _categorizeNfts();
        return true;
      } else {
        _setError(result.failure?.message ?? 'Failed to send NFT');
        return false;
      }
    } catch (e) {
      _setError('Unexpected error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates NFT visibility (hide/unhide)
  Future<void> updateNftHiddenStatus({
    required String nftId,
    required bool isHidden,
  }) async {
    try {
      final result = await updateNftVisibility(UpdateNftVisibilityParams(
        nftId: nftId,
        isHidden: isHidden,
      ));

      if (result.isSuccess) {
        // Update the NFT in the list
        final index = _allNfts.indexWhere((nft) => nft.id == nftId);
        if (index != -1) {
          _allNfts[index] = _allNfts[index].copyWith(isHidden: isHidden);
          _categorizeNfts();
        }
      } else {
        _setError(result.failure?.message ?? 'Failed to update NFT visibility');
      }
    } catch (e) {
      _setError('Unexpected error: $e');
    }
  }

  /// Changes the current tab
  void changeTab(NftTab tab) {
    _currentTab = tab;
    notifyListeners();
  }

  /// Selects an NFT for detail view
  void selectNft(Nft nft) {
    _selectedNft = nft;
    notifyListeners();
  }

  /// Clears the selected NFT
  void clearSelectedNft() {
    _selectedNft = null;
    notifyListeners();
  }

  /// Refreshes the NFT list
  Future<void> refresh() async {
    await loadNfts();
  }

  /// Categorizes NFTs into safe and suspicious lists
  void _categorizeNfts() {
    _safeNfts = _allNfts.where((nft) => !nft.isScam && !nft.isHidden).toList();
    _suspiciousNfts = _allNfts.where((nft) => nft.isScam || nft.isHidden).toList();
    notifyListeners();
  }

  /// Sets loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets error message
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clears error message
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

/// NFT tab enumeration
enum NftTab {
  all,
  suspicious,
}
