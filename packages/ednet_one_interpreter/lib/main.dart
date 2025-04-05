import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:app_links/app_links.dart';
import 'package:ednet_one_interpreter/shell_app.dart';
import 'package:ednet_one_interpreter/presentation/theme.dart';
import 'package:ednet_one_interpreter/generated/one_application.dart';

/// The main entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app links
  final appLinks = AppLinks();

  // Start the app
  runApp(MyApp(appLinks: appLinks));
}

/// The main application widget.
class MyApp extends StatefulWidget {
  /// Creates a new [MyApp] instance.
  const MyApp({Key? key, required this.appLinks}) : super(key: key);

  final AppLinks appLinks;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool useStaging = true; // Default to staging for development
  bool _showLoadingSelector = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDNet One Interpreter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home:
          _showLoadingSelector
              ? _buildEnvironmentSelector()
              : EdnetInterpreterHome(
                appLinks: widget.appLinks,
                useStaging: useStaging,
              ),
    );
  }

  Widget _buildEnvironmentSelector() {
    return Scaffold(
      appBar: AppBar(title: const Text('EDNet One Interpreter')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Domain Model Environment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          useStaging = true;
                          _showLoadingSelector = false;
                        });
                      },
                      child: const Text('Staging Models'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          useStaging = false;
                          _showLoadingSelector = false;
                        });
                      },
                      child: const Text('Production Models'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A home screen that displays the domain selector and environment toggle.
class EdnetInterpreterHome extends StatefulWidget {
  const EdnetInterpreterHome({
    Key? key,
    required this.appLinks,
    required this.useStaging,
  }) : super(key: key);

  final AppLinks appLinks;
  final bool useStaging;

  @override
  State<EdnetInterpreterHome> createState() => _EdnetInterpreterHomeState();
}

class _EdnetInterpreterHomeState extends State<EdnetInterpreterHome> {
  late Domain selectedDomain;
  late Model selectedModel;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDomains();
  }

  void _loadDomains() {
    // Create a temporary OneApplication to load domains
    try {
      final oneApp = OneApplication(useStaging: widget.useStaging);
      print(
        'Loading domains from ${widget.useStaging ? 'staging' : 'production'}...',
      );

      // Check if there are any domains
      if (oneApp.domains.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'No domains available';
        });
        return;
      }

      // Get the first domain and model
      selectedDomain = oneApp.domains.first;
      if (selectedDomain.models.isNotEmpty) {
        selectedModel = selectedDomain.models.first;
        print(
          'Loaded domain: ${selectedDomain.code}, model: ${selectedModel.code}',
        );
      } else {
        _hasError = true;
        _errorMessage = 'Selected domain has no models';
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error loading domains: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading domain models...'),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('EDNet One Interpreter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                  });
                  _loadDomains();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return EdnetOneInterpreterShell(
      domain: selectedDomain,
      model: selectedModel,
      useStaging: widget.useStaging,
    );
  }
}
