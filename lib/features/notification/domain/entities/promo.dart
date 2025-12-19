import 'package:equatable/equatable.dart';

enum PromoType { discount, freebie, happyHour, newItem }

class Promo extends Equatable {
  final String id;
  final String title;
  final String description;
  final PromoType type;
  final String? promoCode;
  final double? discountPercentage;
  final String? freeItemId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String? imageUrl;
  final DateTime createdAt;
  final String createdBy;

  const Promo({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.promoCode,
    this.discountPercentage,
    this.freeItemId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        promoCode,
        discountPercentage,
        freeItemId,
        startDate,
        endDate,
        isActive,
        imageUrl,
        createdAt,
        createdBy,
      ];
}
