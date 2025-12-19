import 'package:brewease_and_reward/features/notification/domain/entities/push_notification.dart';
import 'package:brewease_and_reward/features/notification/domain/entities/promo.dart';
import 'package:equatable/equatable.dart';

class PushNotificationModel extends PushNotification with EquatableMixin {
  const PushNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.imageUrl,
    super.data,
    required super.createdAt,
    super.sentAt,
    required super.isSent,
  });

  factory PushNotificationModel.fromMap(Map<String, dynamic> map) {
    return PushNotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${map['type']}',
        orElse: () => NotificationType.general,
      ),
      imageUrl: map['imageUrl'] as String?,
      data: (map['data'] as Map<String, dynamic>?)?.cast<String, dynamic>(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      sentAt: map['sentAt'] != null
          ? DateTime.parse(map['sentAt'] as String)
          : null,
      isSent: map['isSent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'isSent': isSent,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        imageUrl,
        data,
        createdAt,
        sentAt,
        isSent,
      ];
}

class PromoModel extends Promo with EquatableMixin {
  const PromoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    super.promoCode,
    super.discountPercentage,
    super.freeItemId,
    required super.startDate,
    required super.endDate,
    required super.isActive,
    super.imageUrl,
    required super.createdAt,
    required super.createdBy,
  });

  factory PromoModel.fromMap(Map<String, dynamic> map) {
    return PromoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      type: PromoType.values.firstWhere(
        (e) => e.toString() == 'PromoType.${map['type']}',
        orElse: () => PromoType.discount,
      ),
      promoCode: map['promoCode'] as String?,
      discountPercentage: (map['discountPercentage'] as num?)?.toDouble(),
      freeItemId: map['freeItemId'] as String?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      isActive: map['isActive'] as bool? ?? true,
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      createdBy: map['createdBy'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'promoCode': promoCode,
      'discountPercentage': discountPercentage,
      'freeItemId': freeItemId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

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
