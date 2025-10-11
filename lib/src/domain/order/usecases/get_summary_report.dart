import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../entities/order_summary.dart';
import '../repositories/order_repository.dart';

class GetSummaryReport {
  final OrderRepository repository;

  GetSummaryReport(this.repository);

  Future<Either<Failure, OrderSummary>> call(DateTime date) {
    return repository.getSummary(date: date);
  }
}