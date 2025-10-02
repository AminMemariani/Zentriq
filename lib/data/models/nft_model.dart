import '../../domain/entities/nft.dart';

/// NFT model for data layer
class NftModel extends Nft {
  const NftModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.creator,
    required super.owner,
    required super.tokenId,
    required super.assetId,
    required super.collection,
    required super.mintPrice,
    required super.mintDate,
    super.attributes,
    super.externalUrl,
    super.animationUrl,
    super.isScam,
    super.scamReason,
    super.isHidden,
  });

  /// Creates an NftModel from a JSON map
  factory NftModel.fromJson(Map<String, dynamic> json) {
    return NftModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      creator: json['creator'] as String,
      owner: json['owner'] as String,
      tokenId: json['token_id'] as int,
      assetId: json['asset_id'] as int,
      collection: json['collection'] as String,
      mintPrice: (json['mint_price'] as num).toDouble(),
      mintDate: DateTime.parse(json['mint_date'] as String),
      attributes: json['attributes'] != null
          ? Map<String, dynamic>.from(json['attributes'] as Map)
          : null,
      externalUrl: json['external_url'] as String?,
      animationUrl: json['animation_url'] as String?,
      isScam: json['is_scam'] as bool? ?? false,
      scamReason: json['scam_reason'] as String?,
      isHidden: json['is_hidden'] as bool? ?? false,
    );
  }

  /// Converts this NftModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'creator': creator,
      'owner': owner,
      'token_id': tokenId,
      'asset_id': assetId,
      'collection': collection,
      'mint_price': mintPrice,
      'mint_date': mintDate.toIso8601String(),
      'attributes': attributes,
      'external_url': externalUrl,
      'animation_url': animationUrl,
      'is_scam': isScam,
      'scam_reason': scamReason,
      'is_hidden': isHidden,
    };
  }

  /// Creates an NftModel from an Nft entity
  factory NftModel.fromEntity(Nft nft) {
    return NftModel(
      id: nft.id,
      name: nft.name,
      description: nft.description,
      imageUrl: nft.imageUrl,
      creator: nft.creator,
      owner: nft.owner,
      tokenId: nft.tokenId,
      assetId: nft.assetId,
      collection: nft.collection,
      mintPrice: nft.mintPrice,
      mintDate: nft.mintDate,
      attributes: nft.attributes,
      externalUrl: nft.externalUrl,
      animationUrl: nft.animationUrl,
      isScam: nft.isScam,
      scamReason: nft.scamReason,
      isHidden: nft.isHidden,
    );
  }
}

/// NFT transaction model for data layer
class NftTransactionModel extends NftTransaction {
  const NftTransactionModel({
    required super.id,
    required super.nftId,
    required super.fromAddress,
    required super.toAddress,
    required super.amount,
    required super.timestamp,
    super.note,
    super.fee,
    super.status,
  });

  /// Creates an NftTransactionModel from a JSON map
  factory NftTransactionModel.fromJson(Map<String, dynamic> json) {
    return NftTransactionModel(
      id: json['id'] as String,
      nftId: json['nft_id'] as String,
      fromAddress: json['from_address'] as String,
      toAddress: json['to_address'] as String,
      amount: json['amount'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
      fee: json['fee'] != null ? (json['fee'] as num).toDouble() : null,
      status: NftTransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => NftTransactionStatus.pending,
      ),
    );
  }

  /// Converts this NftTransactionModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nft_id': nftId,
      'from_address': fromAddress,
      'to_address': toAddress,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'fee': fee,
      'status': status.name,
    };
  }

  /// Creates an NftTransactionModel from an NftTransaction entity
  factory NftTransactionModel.fromEntity(NftTransaction transaction) {
    return NftTransactionModel(
      id: transaction.id,
      nftId: transaction.nftId,
      fromAddress: transaction.fromAddress,
      toAddress: transaction.toAddress,
      amount: transaction.amount,
      timestamp: transaction.timestamp,
      note: transaction.note,
      fee: transaction.fee,
      status: transaction.status,
    );
  }
}
