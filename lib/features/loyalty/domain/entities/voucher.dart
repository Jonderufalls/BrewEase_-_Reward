import 'package:equatable/equatable.dart';

class Voucher extends Equatable {
  final String id;
  final String rewardTierId;
  final String userId;
  final String code;
  final bool isRedeemed;
  final DateTime createdAt;
  final DateTime? redeemedAt;
  final DateTime expiresAt;

  const Voucher({
    required this.id,
    required this.rewardTierId,
    required this.userId,
    required this.code,
    required this.isRedeemed,
    required this.createdAt,
    this.redeemedAt,
    required this.expiresAt,
  });

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
