import 'package:equatable/equatable.dart';

class OrderSummary extends Equatable {
  final DateTime date;
  final double salesTotal;
  final int orderCount;
  final Map<String, int> topItems; // itemId -> qty sold
  final int loyaltyRedemptions;

  const OrderSummary({
    required this.date,
    required this.salesTotal,
    required this.orderCount,
    required this.topItems,
    required this.loyaltyRedemptions,
  });

  @override
  List<Object?> get props => [date, salesTotal, orderCount, topItems, loyaltyRedemptions];
}