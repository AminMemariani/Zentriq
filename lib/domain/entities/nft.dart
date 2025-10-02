import 'package:equatable/equatable.dart';

/// NFT entity representing an Algorand Standard Asset (ASA) NFT
class Nft extends Equatable {
  const Nft({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.creator,
    required this.owner,
    required this.tokenId,
    required this.assetId,
    required this.collection,
    required this.mintPrice,
    required this.mintDate,
    this.attributes,
    this.externalUrl,
    this.animationUrl,
    this.isScam = false,
    this.scamReason,
    this.isHidden = false,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String creator;
  final String owner;
  final int tokenId;
  final int assetId;
  final String collection;
  final double mintPrice;
  final DateTime mintDate;
  final Map<String, dynamic>? attributes;
  final String? externalUrl;
  final String? animationUrl;
  final bool isScam;
  final String? scamReason;
  final bool isHidden;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        creator,
        owner,
        tokenId,
        assetId,
        collection,
        mintPrice,
        mintDate,
        attributes,
        externalUrl,
        animationUrl,
        isScam,
        scamReason,
        isHidden,
      ];

  /// Returns formatted mint price with ALGO symbol
  String get formattedMintPrice => '${mintPrice.toStringAsFixed(2)} ALGO';

  /// Returns formatted mint date
  String get formattedMintDate {
    final now = DateTime.now();
    final difference = now.difference(mintDate);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Returns a short description (first 100 characters)
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 100)}...';
  }

  /// Returns the NFT with updated hidden status
  Nft copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? creator,
    String? owner,
    int? tokenId,
    int? assetId,
    String? collection,
    double? mintPrice,
    DateTime? mintDate,
    Map<String, dynamic>? attributes,
    String? externalUrl,
    String? animationUrl,
    bool? isScam,
    String? scamReason,
    bool? isHidden,
  }) {
    return Nft(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      creator: creator ?? this.creator,
      owner: owner ?? this.owner,
      tokenId: tokenId ?? this.tokenId,
      assetId: assetId ?? this.assetId,
      collection: collection ?? this.collection,
      mintPrice: mintPrice ?? this.mintPrice,
      mintDate: mintDate ?? this.mintDate,
      attributes: attributes ?? this.attributes,
      externalUrl: externalUrl ?? this.externalUrl,
      animationUrl: animationUrl ?? this.animationUrl,
      isScam: isScam ?? this.isScam,
      scamReason: scamReason ?? this.scamReason,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}

/// NFT transaction entity for sending NFTs
class NftTransaction extends Equatable {
  const NftTransaction({
    required this.id,
    required this.nftId,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.timestamp,
    this.note,
    this.fee,
    this.status = NftTransactionStatus.pending,
  });

  final String id;
  final String nftId;
  final String fromAddress;
  final String toAddress;
  final int amount; // Always 1 for NFTs
  final DateTime timestamp;
  final String? note;
  final double? fee;
  final NftTransactionStatus status;

  @override
  List<Object?> get props => [
        id,
        nftId,
        fromAddress,
        toAddress,
        amount,
        timestamp,
        note,
        fee,
        status,
      ];

  /// Returns formatted timestamp
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

/// NFT transaction status enum
enum NftTransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

/// NFT scam detection reasons
enum NftScamReason {
  blacklistedCreator,
  suspiciousMetadata,
  lowMintPrice,
  suspiciousCollection,
  duplicateContent,
  phishingAttempt,
}
