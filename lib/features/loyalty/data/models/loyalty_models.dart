import 'package:brewease_and_reward/features/loyalty/domain/entities/reward_tier.dart';
import 'package:brewease_and_reward/features/loyalty/domain/entities/loyalty_account.dart';
import 'package:brewease_and_reward/features/loyalty/domain/entities/voucher.dart';
import 'package:equatable/equatable.dart';

class RewardTierModel extends RewardTier with EquatableMixin {
  const RewardTierModel({
    required super.id,
    required super.name,
    required super.pointsRequired,
    required super.rewardDescription,
    required super.rewardType,
    required super.rewardValue,
    required super.isActive,
  });

  factory RewardTierModel.fromMap(Map<String, dynamic> map) {
    return RewardTierModel(
      id: map['id'] as String,
      name: map['name'] as String,
      pointsRequired: (map['pointsRequired'] as num).toInt(),
      rewardDescription: map['rewardDescription'] as String,
      rewardType: map['rewardType'] as String,
      rewardValue: (map['rewardValue'] as num).toDouble(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pointsRequired': pointsRequired,
      'rewardDescription': rewardDescription,
      'rewardType': rewardType,
      'rewardValue': rewardValue,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        pointsRequired,
        rewardDescription,
        rewardType,
        rewardValue,
        isActive,
      ];
}

class LoyaltyAccountModel extends LoyaltyAccount with EquatableMixin {
  const LoyaltyAccountModel({
    required super.id,
    required super.userId,
    required super.currentPoints,
    required super.totalPointsEarned,
    required super.redeemedVoucherIds,
    required super.createdAt,
    required super.lastUpdatedAt,
  });

  factory LoyaltyAccountModel.fromMap(Map<String, dynamic> map) {
    return LoyaltyAccountModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      currentPoints: (map['currentPoints'] as num).toInt(),
      totalPointsEarned: (map['totalPointsEarned'] as num).toInt(),
      redeemedVoucherIds:
          (map['redeemedVoucherIds'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastUpdatedAt: DateTime.parse(map['lastUpdatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'currentPoints': currentPoints,
      'totalPointsEarned': totalPointsEarned,
      'redeemedVoucherIds': redeemedVoucherIds,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        currentPoints,
        totalPointsEarned,
        redeemedVoucherIds,
        createdAt,
        lastUpdatedAt,
      ];
}

class VoucherModel extends Voucher with EquatableMixin {
  const VoucherModel({
    required super.id,
    required super.rewardTierId,
    required super.userId,
    required super.code,
    required super.isRedeemed,
    required super.createdAt,
    super.redeemedAt,
    required super.expiresAt,
  });

  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      id: map['id'] as String,
      rewardTierId: map['rewardTierId'] as String,
      userId: map['userId'] as String,
      code: map['code'] as String,
      isRedeemed: map['isRedeemed'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      redeemedAt: map['redeemedAt'] != null
          ? DateTime.parse(map['redeemedAt'] as String)
          : null,
      expiresAt: DateTime.parse(map['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rewardTierId': rewardTierId,
      'userId': userId,
      'code': code,
      'isRedeemed': isRedeemed,
      'createdAt': createdAt.toIso8601String(),
      'redeemedAt': redeemedAt?.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        rewardTierId,
        userId,
        code,
        isRedeemed,
        createdAt,
        redeemedAt,
        expiresAt,
      ];
}
