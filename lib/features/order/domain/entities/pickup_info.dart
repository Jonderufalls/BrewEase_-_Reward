import 'package:equatable/equatable.dart';

class PickupInfo extends Equatable {
  final bool asap;
  final DateTime? scheduledAt;
  final String locationId; // store/pickup location id
  final String instructions;

  const PickupInfo({
    required this.asap,
    this.scheduledAt,
    required this.locationId,
    this.instructions = '',
  });

  @override
  List<Object?> get props => [asap, scheduledAt, locationId, instructions];
}