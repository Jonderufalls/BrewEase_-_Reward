import 'package:equatable/equatable.dart';

enum NotificationType { promotion, order, loyalty, general }

class PushNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime? sentAt;
  final bool isSent;

  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.imageUrl,
    this.data,
    required this.createdAt,
    this.sentAt,
    required this.isSent,
  });

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
