import 'package:app_links/app_links.dart';
import 'package:ednet_cms/ednet_cms.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import 'package:ednet_one/presentation/widgets/layout/graph/algorithms/master_detail_layout_algorithm.dart';
import 'package:ednet_one/presentation/widgets/layout/web/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/layout_block.dart';
import '../blocs/layout_event.dart';
import '../blocs/layout_state.dart';
import '../blocs/theme_block.dart';
import '../blocs/theme_event.dart';
import '../theme.dart';
import '../widgets/layout/graph/layout/layout_algorithm.dart';
import '../widgets/layout/graph/painters/meta_domain_canvas.dart';
import '../widgets/layout/web/footer_widget.dart';
import '../widgets/layout/web/left_sidebar_widget.dart';
import '../widgets/layout/web/main_content_widget.dart';
import '../widgets/layout/web/right_sidebar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.appLinks});

  final String title;
  final AppLinks appLinks;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> path = ['Home'];

  late IOneApplication app;
  Domain? selectedDomain;
  Model? selectedModel;
  Entities? selectedEntries;
  Entities? selectedEntities;
  Concept? selectedConcept;

  List<Bookmark> bookmarks = [];
  BookmarkManager bookmarkManager = BookmarkManager();

  bool showMetaCanvas = false;
  LayoutAlgorithm _selectedAlgorithm = MasterDetailLayoutAlgorithm();
  Matrix4? _savedTransformation;

  @override
  void initState() {
    super.initState();
    initializeApp();
    widget.appLinks.uriLinkStream.listen(_handleBookmarkSelected);
  }

  void initializeApp() {
    app = OneApplication();

    if (app.groupedDomains.isNotEmpty) {
      selectedDomain = app.groupedDomains.first;

      if (selectedDomain!.models.isNotEmpty) {
        selectedModel = selectedDomain!.models.first;
        selectedEntries = selectedModel!.concepts;
      }
    }
  }

  void _handleDomainSelected(Domain domain) {
    setState(() {
      selectedDomain = domain;
      selectedModel = domain.models.isNotEmpty ? domain.models.first : null;
      selectedEntries = selectedModel?.concepts.isNotEmpty ?? false
          ? selectedModel!.concepts
          : null;
    });
  }

  void _handleModelSelected(Model model) {
    setState(() {
      selectedModel = model;
      selectedEntries =
          model.concepts.isNotEmpty ? model.getOrderedEntryConcepts() : null;
    });
  }

  void _handleBookmarkSelected(Uri? uri) {
    if (uri != null) {
      // Implement bookmark selection logic here
    }
  }

  void _handleConceptSelected(Concept concept) {
    var domainModel = app.getDomainModels(selectedDomain!.codeFirstLetterLower,
        selectedModel!.codeFirstLetterLower);
    var modelEntries = domainModel.getModelEntries(concept.model.code);
    var entry = modelEntries?.getEntry(concept.code);
    setState(() {
      selectedConcept = concept;
      selectedEntities = entry;
    });
  }

  void _changeLayoutAlgorithm(LayoutAlgorithm algorithm) {
    setState(() {
      _savedTransformation ??= Matrix4.identity();
      _selectedAlgorithm = algorithm;
    });
  }

  void _saveTransformation(Matrix4 transformation) {
    setState(() {
      _savedTransformation = transformation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          for (var domain in app.groupedDomains) buildDomainButton(domain),
          const Spacer(),
          ThemeDropdown(),
          buildIconButton(Icons.view_quilt, () {
            setState(() {
              showMetaCanvas = !showMetaCanvas;
            });
          }),
          buildIconButton(Icons.swap_horiz, () {
            context.read<LayoutBloc>().add(ToggleLayoutEvent());
          }),
          buildIconButton(Icons.brightness_6, () {
            context.read<ThemeBloc>().add(ToggleThemeEvent());
          }),
        ],
      ),
    );
  }

  Widget buildDomainButton(Domain domain) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => _handleDomainSelected(domain),
        child: Text(domain.code),
      ),
    );
  }

  IconButton buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutBloc(),
      child: BlocBuilder<LayoutBloc, LayoutState>(
        builder: (context, state) {
          return showMetaCanvas
              ? buildMetaDomainCanvas()
              : buildLayoutTemplate();
        },
      ),
    );
  }

  MetaDomainCanvas buildMetaDomainCanvas() {
    final transitDomains = Domains();
    transitDomains.add(selectedDomain!);

    return MetaDomainCanvas(
      domains: transitDomains,
      initialTransformation: _savedTransformation,
      onTransformationChanged: _saveTransformation,
      onChangeLayoutAlgorithm: _changeLayoutAlgorithm,
      layoutAlgorithm: _selectedAlgorithm,
      decorators: [],
    );
  }

  Scaffold buildLayoutTemplate() {
    return Scaffold(
      appBar: AppBar(
        title: buildHeader(),
      ),
      body: Row(
        children: [
          buildLeftSidebar(),
          buildMainContent(),
          buildRightSidebar(),
        ],
      ),
      bottomNavigationBar: const FooterWidget(),
    );
  }

  Widget buildLeftSidebar() {
    return Expanded(
      flex: 2,
      child: LeftSidebarWidget(
        entries: selectedEntries as Concepts,
        onConceptSelected: _handleConceptSelected,
      ),
    );
  }

  Widget buildMainContent() {
    return Expanded(
      flex: 8,
      child: selectedConcept != null
          ? MainContentWidget(
              entities: selectedEntities ?? Entities<Concept>(),
            )
          : const Text('No Concept selected'),
    );
  }

  Widget buildRightSidebar() {
    return selectedDomain != null
        ? Expanded(
            flex: 2,
            child: RightSidebarWidget(
              models: selectedDomain!.models,
              onModelSelected: _handleModelSelected,
            ),
          )
        : const Text('No Domain selected');
  }

  HeaderWidget buildHeader() {
    return HeaderWidget(
      filters: [],
      onAddFilter: (criteria) => print(criteria),
      onBookmark: () => print('onBookmark'),
      onPathSegmentTapped: print,
      path: path,
    );
  }
}

class ThemeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeBloc>().state;
    final brightness = themeState.isDarkMode ? 'dark' : 'light';
    final currentThemeName = themes[brightness]!.keys.firstWhere(
        (themeName) => themes[brightness]![themeName] == themeState.themeData,
        orElse: () => themes[brightness]!.keys.first);

    return DropdownButton<String>(
      value: currentThemeName,
      hint: Text('Select Theme'),
      items: themes[brightness]!.keys.map((String themeName) {
        return DropdownMenuItem<String>(
          value: themeName,
          child: Text(themeName),
        );
      }).toList(),
      onChanged: (themeName) {
        if (themeName != null) {
          final themeData = themes[brightness]![themeName]!;
          context.read<ThemeBloc>().add(ChangeThemeEvent(themeData));
        }
      },
    );
  }
}
