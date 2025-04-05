import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/presentation/navigation/navigation_service.dart';
import 'package:ednet_one/presentation/state/blocs/concept_selection/concept_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/theme_bloc/theme_bloc.dart';
import 'package:ednet_one/presentation/state/providers/domain_service.dart';
import 'package:ednet_one/presentation/theme/theme_service.dart';
import 'package:get_it/get_it.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Initializes the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Core
  _registerApplicationCore();

  // Services
  _registerServices();

  // BLoCs
  _registerBlocs();
}

/// Register core application dependencies
void _registerApplicationCore() {
  // Register OneApplication as a singleton
  sl.registerLazySingleton<OneApplication>(() => OneApplication());

  // Register the OneApplication as an implementation of IOneApplication
  sl.registerLazySingleton<IOneApplication>(() => sl<OneApplication>());
}

/// Register service providers
void _registerServices() {
  // Navigation Service
  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  // Domain Service
  sl.registerLazySingleton<DomainService>(
    () => DomainService(sl<OneApplication>()),
  );

  // Theme Service
  sl.registerLazySingleton<ThemeService>(() => ThemeService());
}

/// Register BLoC instances
void _registerBlocs() {
  // Domain Selection Bloc
  sl.registerFactory<DomainSelectionBloc>(
    () => DomainSelectionBloc(app: sl<IOneApplication>()),
  );

  // Model Selection Bloc
  sl.registerFactory<ModelSelectionBloc>(
    () => ModelSelectionBloc(app: sl<IOneApplication>()),
  );

  // Concept Selection Bloc
  sl.registerFactory<ConceptSelectionBloc>(
    () => ConceptSelectionBloc(app: sl<IOneApplication>()),
  );

  // Theme Bloc
  sl.registerFactory<ThemeBloc>(() => ThemeBloc());
}
