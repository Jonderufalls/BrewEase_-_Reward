import 'package:equatable/equatable.dart';

class RewardTier extends Equatable {
  final String id;
  final String name;
  final int pointsRequired;
  final String rewardDescription;
  final String rewardType; // e.g., 'discount', 'freebie', 'voucher'
  final double rewardValue; // e.g., discount percentage or points worth
  final bool isActive;

  const RewardTier({
    required this.id,
    required this.name,
    required this.pointsRequired,
    required this.rewardDescription,
    required this.rewardType,
    required this.rewardValue,
    required this.isActive,
  });

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
