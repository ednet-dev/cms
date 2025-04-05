import 'package:ednet_core/ednet_core.dart';

/// Interface for the One Application
///
/// This interface defines the essential operations that the application
/// provides, making it easier to create mock implementations for testing.
abstract class IOneApplication {
  /// Get all domains in the application
  Domains get domains;

  /// Get grouped domains (domains with the same code merged together)
  Domains get groupedDomains;

  /// Get specific domain models by domain and model code
  DomainModels getDomainModels(String domain, String model);
}
