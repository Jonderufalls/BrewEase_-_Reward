import 'package:brewease_and_reward/features/user/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class UserModel extends AppUser with EquatableMixin {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.role = UserRole.customer,
    super.avatarUrl,
    super.phone,
    super.defaultPaymentMethod,
    super.defaultPickupLocation,
    super.loyaltyPoints = 0,
    super.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['role'] ?? 'customer'}',
        orElse: () => UserRole.customer,
      ),
      avatarUrl: map['avatarUrl'] as String?,
      phone: map['phone'] as String?,
      defaultPaymentMethod: map['defaultPaymentMethod'] as String?,
      defaultPickupLocation: map['defaultPickupLocation'] as String?,
      loyaltyPoints: (map['loyaltyPoints'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'avatarUrl': avatarUrl,
      'phone': phone,
      'defaultPaymentMethod': defaultPaymentMethod,
      'defaultPickupLocation': defaultPickupLocation,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        avatarUrl,
        phone,
        defaultPaymentMethod,
        defaultPickupLocation,
        loyaltyPoints,
        createdAt,
      ];
}
