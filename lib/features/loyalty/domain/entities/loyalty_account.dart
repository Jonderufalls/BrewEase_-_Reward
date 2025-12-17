import 'package:equatable/equatable.dart';

class LoyaltyAccount extends Equatable {
  final String id;
  final String userId;
  final int currentPoints;
  final int totalPointsEarned;
  final List<String> redeemedVoucherIds;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  const LoyaltyAccount({
    required this.id,
    required this.userId,
    required this.currentPoints,
    required this.totalPointsEarned,
    required this.redeemedVoucherIds,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

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
