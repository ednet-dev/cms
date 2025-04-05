import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:ednet_one_interpreter/generated/one_application.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_block.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_event.dart';
import 'package:ednet_one_interpreter/presentation/blocs/layout_block.dart';
import 'package:ednet_one_interpreter/presentation/blocs/theme_block.dart';
import 'package:ednet_one_interpreter/presentation/screens/home_page.dart';
import 'package:ednet_one_interpreter/presentation/theme.dart';
import 'package:ednet_one_interpreter/models/code_generator.dart';
import 'package:ednet_one_interpreter/models/draft_manager.dart';
import 'package:ednet_one_interpreter/features/domain_visualization/domain_visualization_screen.dart';

/// A shell application for interpreting domain models.
///
/// This widget serves as the main entry point for interpreting and displaying
/// domain models defined in ednet_core. It provides a framework for rendering
/// and interacting with domain-specific UI components.
class EdnetOneInterpreterShell extends StatefulWidget {
  /// Creates a new instance of [EdnetOneInterpreterShell].
  const EdnetOneInterpreterShell({
    super.key,
    required this.domain,
    required this.model,
    this.useStaging = false,
  });

  /// The domain model to interpret and display.
  final Domain domain;
  final Model model;
  final bool useStaging;

  @override
  State<EdnetOneInterpreterShell> createState() =>
      _EdnetOneInterpreterShellState();
}

class _EdnetOneInterpreterShellState extends State<EdnetOneInterpreterShell> {
  late final IOneApplication _app;
  late final AppLinks _appLinks;
  late final ShellApp _shellApp;

  @override
  void initState() {
    super.initState();
    _app = OneApplication(useStaging: widget.useStaging);
    _shellApp = ShellApp(useStaging: widget.useStaging);
    _appLinks = AppLinks();

    // Ensure that the domain and model from props are loaded if provided
    if (widget.domain != null && widget.model != null) {
      // Delay to ensure BlocProvider is available
      Future.microtask(() {
        final domainBloc = context.read<DomainBloc>();

        // First select the domain
        domainBloc.add(SelectDomainEvent(widget.domain));

        // Then select the model
        domainBloc.add(SelectModelEvent(widget.model));

        // Force a reload of available specifications
        domainBloc.add(ListSpecificationsEvent());

        // Also load drafts
        domainBloc.add(ListDraftsEvent());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DomainBloc>(
          create:
              (context) =>
                  DomainBloc(app: _shellApp)..add(InitializeDomainEvent()),
        ),
        BlocProvider<LayoutBloc>(create: (context) => LayoutBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'EDNet One Interpreter',
            theme: themeState.themeData,
            home: _choosePage(),
          );
        },
      ),
    );
  }

  Widget _choosePage() {
    // For this example, we'll show the domain visualization screen directly
    // if a domain and model are provided in the constructor
    if (widget.domain != null && widget.model != null) {
      return const DomainVisualizationScreen();
    }

    // Otherwise, show the home page
    return HomePage(
      title: 'EDNet Domain Model Interpreter',
      appLinks: _appLinks,
    );
  }
}

/// A class that manages the domain model registry and provides access to both
/// production and staging domains.
///
/// This class serves as the interface for accessing domain models and coordinating
/// domain-specific operations such as code generation.
class ShellApp implements IOneApplication {
  final OneApplication _oneApplication;
  final bool useStaging;
  late final CodeGenerator _codeGenerator;
  late final DraftManager _draftManager;

  ShellApp({this.useStaging = false})
    : _oneApplication = OneApplication(useStaging: useStaging) {
    final env = useStaging ? 'staging' : 'production';
    _codeGenerator = CodeGenerator(env: env);
    _draftManager = DraftManager(env: env);
  }

  @override
  Domains get domains => _oneApplication.domains;

  @override
  Domains get groupedDomains => _oneApplication.groupedDomains;

  @override
  DomainModels getDomainModels(String domain, String model) =>
      _oneApplication.getDomainModels(domain, model);

  /// Generates code from the DSL specification in the requirements folder.
  ///
  /// Based on whether we're using staging or production environment, this will
  /// target the appropriate requirements folder.
  Future<bool> generateCode(Domain domain, Model model) async {
    return _codeGenerator.generateCode(domain, model);
  }

  /// Updates a domain model based on user edits.
  ///
  /// This enables in-vivo domain model editing by updating the underlying
  /// specification files and triggering code regeneration as needed.
  Future<bool> updateDomainModel(
    Domain domain,
    Model model,
    Map<String, dynamic> updates,
  ) async {
    // Apply updates to the domain model
    // This is a simplified placeholder - actual implementation would update the model
    // based on the provided updates map

    // Save updated specification
    final success = await _codeGenerator.updateSpecification(domain, model);

    // Regenerate code if specification was updated successfully
    if (success) {
      return _codeGenerator.generateCode(domain, model);
    }

    return false;
  }

  /// Saves changes to the domain model to the requirements folder.
  ///
  /// This method persists any changes made to the domain model during
  /// in-vivo editing sessions to the appropriate requirements files.
  Future<bool> saveDomainModelChanges(Domain domain, Model model) async {
    return _codeGenerator.updateSpecification(domain, model);
  }

  /// Exports the current domain model as a DSL specification.
  ///
  /// This is useful for visualizing the current state of the domain model
  /// or for sharing model definitions with other systems.
  String exportDomainModelAsDSL(Domain domain, Model model) {
    StringBuffer dsl = StringBuffer();

    // Generate a simple DSL representation of the domain model
    dsl.writeln('domain ${domain.code} {');

    // Add domain properties
    dsl.writeln('  description: "${domain.description}"');

    // Include model definition
    dsl.writeln('  model ${model.code} {');
    dsl.writeln('    description: "${model.description}"');

    // Add concepts
    for (var concept in model.concepts) {
      dsl.writeln('    concept ${concept.code} {');
      dsl.writeln('      description: "${concept.description}"');

      // Add attributes if available
      // This is a simplified representation - the actual model would have more details

      dsl.writeln('    }');
    }

    dsl.writeln('  }');
    dsl.writeln('}');

    return dsl.toString();
  }

  /// Lists all available domain model specifications.
  ///
  /// Returns a map of domain codes to lists of model codes that have specifications.
  Future<Map<String, List<String>>> listAvailableSpecifications() async {
    return _codeGenerator.listAvailableSpecifications();
  }

  /// Saves a draft of the current domain model.
  ///
  /// This is used for auto-save functionality and to preserve unsaved changes
  /// between application sessions.
  Future<bool> saveDraft(Domain domain, Model model) async {
    return _draftManager.saveDraft(domain, model);
  }

  /// Loads a draft of a domain model.
  ///
  /// Returns the draft as a YAML string that can be parsed into a domain model.
  Future<String?> loadDraft(String domainCode, String modelCode) async {
    return _draftManager.loadDraft(domainCode, modelCode);
  }

  /// Checks if a draft exists for the specified domain and model.
  Future<bool> hasDraft(String domainCode, String modelCode) async {
    return _draftManager.hasDraft(domainCode, modelCode);
  }

  /// Lists all available drafts.
  Future<Map<String, List<String>>> listAvailableDrafts() async {
    return _draftManager.listAvailableDrafts();
  }

  /// Gets metadata for a draft if it exists.
  Future<Map<String, dynamic>?> getDraftMetadata(
    String domainCode,
    String modelCode,
  ) async {
    return _draftManager.getDraftMetadata(domainCode, modelCode);
  }

  /// Commits a draft to the main specification.
  Future<bool> commitDraft(String domainCode, String modelCode) async {
    return _draftManager.commitDraft(domainCode, modelCode);
  }

  /// Discards a draft.
  Future<bool> discardDraft(String domainCode, String modelCode) async {
    return _draftManager.discardDraft(domainCode, modelCode);
  }

  /// Lists all available versions for a domain model.
  Future<List<String>> listVersions(String domainCode, String modelCode) async {
    return _draftManager.listVersions(domainCode, modelCode);
  }

  /// Loads a specific version of a domain model.
  Future<String?> loadVersion(
    String domainCode,
    String modelCode,
    String versionTimestamp,
  ) async {
    return _draftManager.loadVersion(domainCode, modelCode, versionTimestamp);
  }
}
