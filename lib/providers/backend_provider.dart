import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/backend_service.dart';

// Singleton provider for BackendService
final backendServiceProvider = Provider<BackendService>((ref) {
  return BackendService();
});
