import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/order_repository.dart';

class ExportOrdersCsvParams {
  final DateTime from;
  final DateTime to;

  ExportOrdersCsvParams({required this.from, required this.to});
}

class ExportOrdersCsv {
  final OrderRepository repository;

  ExportOrdersCsv(this.repository);

  /// Returns CSV content or a URL depending on implementation.
  Future<Either<Failure, String>> call(ExportOrdersCsvParams params) {
    return repository.exportOrdersCsv(from: params.from, to: params.to);
  }
}