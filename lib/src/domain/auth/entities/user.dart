import 'package:equatable/equatable.dart';

enum UserRole { customer, owner }

extension UserRoleX on UserRole {
  String toShortString() => toString().split('.').last;
  static UserRole fromString(String s) {
    return UserRole.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == s.toLowerCase(),
      orElse: () => UserRole.customer,
    );
  }
}

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final UserRole role;
  final String? avatarUrl;
  final String? phone;
  final String? defaultPaymentMethod;
  final String? defaultPickupLocation;
  final int loyaltyPoints;
  final DateTime? createdAt;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.role = UserRole.customer,
    this.avatarUrl,
    this.phone,
    this.defaultPaymentMethod,
    this.defaultPickupLocation,
    this.loyaltyPoints = 0,
    this.createdAt,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? avatarUrl,
    String? phone,
    String? defaultPaymentMethod,
    String? defaultPickupLocation,
    int? loyaltyPoints,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      defaultPickupLocation: defaultPickupLocation ?? this.defaultPickupLocation,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role.toShortString(),
        'avatarUrl': avatarUrl,
        'phone': phone,
        'defaultPaymentMethod': defaultPaymentMethod,
        'defaultPickupLocation': defaultPickupLocation,
        'loyaltyPoints': loyaltyPoints,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      role: map['role'] != null ? UserRoleX.fromString(map['role'] as String) : UserRole.customer,
      avatarUrl: map['avatarUrl'] as String?,
      phone: map['phone'] as String?,
      defaultPaymentMethod: map['defaultPaymentMethod'] as String?,
      defaultPickupLocation: map['defaultPickupLocation'] as String?,
      loyaltyPoints: (map['loyaltyPoints'] as int?) ?? 0,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
    );
  }

  @override
  List<Object?> get props => [id, email, name, role, avatarUrl, phone, defaultPaymentMethod, defaultPickupLocation, loyaltyPoints, createdAt];
}