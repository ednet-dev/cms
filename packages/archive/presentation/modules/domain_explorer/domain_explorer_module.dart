import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one/generated/one_application.dart';
import '../../../presentation/layouts/app_module.dart';
import '../../../presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import '../../../presentation/state/blocs/domain_selection/domain_selection_event.dart';
import '../../../presentation/state/blocs/domain_selection/domain_selection_state.dart';
import '../../../presentation/theme/providers/theme_provider.dart';
import '../../../presentation/theme/extensions/theme_spacing.dart';
import '../../../presentation/widgets/semantic_concept_container.dart';
import '../../../presentation/widgets/card/enhanced_card.dart';
import '../../../presentation/widgets/list/enhanced_list_item.dart';
import 'domain_detail_view.dart';
import '../../widgets/breadcrumb/breadcrumb.dart';

/// Domain Explorer Module - handles browsing, selecting and managing domains
class DomainExplorerModule extends AppModule {
  final IOneApplication _app;

  DomainExplorerModule(this._app);

  @override
  String get id => 'domains';

  @override
  String get name => 'Domains';

  @override
  IconData get icon => Icons.category;

  @override
  Widget buildModuleContent(BuildContext context) {
    return const DomainExplorerScreen();
  }

  @override
  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Refresh domains',
        onPressed: () {
          // Use our custom event
          context.read<DomainSelectionBloc>().add(RefreshDomainsEvent());
        },
      ),
    ];
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Implement domain creation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Domain creation not implemented yet')),
        );
      },
      tooltip: 'Add Domain',
      child: const Icon(Icons.add),
    );
  }
}

/// The main screen for the Domain Explorer module with master-detail layout
class DomainExplorerScreen extends StatelessWidget {
  const DomainExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, state) {
        // Build breadcrumb navigation
        final List<BreadcrumbItem> breadcrumbs = [
          BreadcrumbItem(
            label: 'Domains',
            icon: Icons.category,
            onTap: () {
              // Clear domain selection to return to list view
              if (state.selectedDomain != null) {
                context.read<DomainSelectionBloc>().add(
                  ClearDomainSelectionEvent(),
                );
              }
            },
          ),
          if (state.selectedDomain != null)
            BreadcrumbItem(
              label: state.selectedDomain!.code,
              icon: Icons.domain,
              subtitle: '${state.selectedDomain!.models.length} models',
              current: true,
            ),
        ];

        return SemanticConceptContainer(
          conceptType: 'DomainExplorer',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Breadcrumb navigation
              BreadcrumbBar(items: breadcrumbs, title: 'Domain Navigation'),

              // Content area with master-detail pattern
              Expanded(child: _buildContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DomainSelectionState state) {
    // Check if a domain is selected
    if (state.selectedDomain != null) {
      // Detail view for selected domain
      return DomainDetailView(domain: state.selectedDomain!);
    }

    // Master view (list of domains)
    return _buildDomainList(context, state);
  }

  Widget _buildDomainList(BuildContext context, DomainSelectionState state) {
    // Check if the domains are being loaded or empty
    if (state.availableDomains.isEmpty) {
      return Center(
        child: Text(
          'No domains available',
          style: context.conceptTextStyle('Error'),
        ),
      );
    }

    // Convert Domains to List<Domain> for our DomainList
    final domains = state.availableDomains.toList();
    return DomainList(domains: domains);
  }
}

/// Widget to display a list of domains
class DomainList extends StatelessWidget {
  final List<Domain> domains;

  const DomainList({super.key, required this.domains});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout - use grid for wider screens, list for narrow
        final bool useGrid = constraints.maxWidth > 600;

        if (useGrid) {
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: domains.length,
            itemBuilder: (context, index) {
              return DomainCard(domain: domains[index]);
            },
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: domains.length,
            itemBuilder: (context, index) {
              return DomainListItem(domain: domains[index]);
            },
          );
        }
      },
    );
  }
}

/// Card view of a domain for grid layout
class DomainCard extends StatelessWidget {
  final Domain domain;

  const DomainCard({super.key, required this.domain});

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: EnhancedCard(
        conceptType: 'Domain',
        leadingIcon: Icons.category,
        badgeText: _getHighlightedInfoText(),
        onTap: () => _selectDomain(context, domain),
        isAggregateRoot: true,
        importance: 0.8,
        header: Text(
          domain.code,
          style: context.conceptTextStyle('Domain', role: 'header'),
          overflow: TextOverflow.ellipsis,
        ),
        footer: Row(
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 14,
              color: context
                  .conceptColor('Domain', role: 'icon')
                  .withOpacity(0.7),
            ),
            SizedBox(width: context.spacingXs),
            Text(
              '${domain.models.length} models',
              style: context.conceptTextStyle('Domain', role: 'subtitle'),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.spacingM),
          child: _buildDomainDescription(),
        ),
      ),
    );
  }

  Widget _buildDomainDescription() {
    // In a real app, we'd show actual domain metadata here
    // For now, we'll just show a brief description based on model count

    if (domain.models.isEmpty) {
      return Text(
        'Empty domain with no models',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }

    final topModels = domain.models.take(3).map((m) => m.code).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (domain.models.length > 0)
          Text(
            'Models: $topModels${domain.models.length > 3 ? '...' : ''}',
            style: TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  String? _getHighlightedInfoText() {
    // Highlight something interesting about the domain
    if (domain.models.length > 5) {
      return '${domain.models.length} models';
    }
    return null;
  }

  void _selectDomain(BuildContext context, Domain domain) {
    context.read<DomainSelectionBloc>().add(SelectDomainEvent(domain));
  }
}

/// List item view of a domain for list layout
class DomainListItem extends StatelessWidget {
  final Domain domain;

  const DomainListItem({super.key, required this.domain});

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: EnhancedListItem(
        title: domain.code,
        subtitle: _getModelSummary(),
        leadingIcon: Icons.category,
        conceptType: 'Domain',
        isAggregateRoot: true,
        importance: 0.8,
        badgeText: domain.models.length > 0 ? '${domain.models.length}' : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: context.conceptColor('Domain', role: 'icon').withOpacity(0.5),
        ),
        onTap: () => _selectDomain(context, domain),
        secondaryActionIcon: Icons.info_outline,
        onSecondaryAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Domain info: ${domain.code}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  String _getModelSummary() {
    if (domain.models.isEmpty) {
      return 'No models';
    }

    final modelNames = domain.models.take(3).map((m) => m.code).join(', ');
    if (domain.models.length > 3) {
      return '$modelNames and ${domain.models.length - 3} more';
    }
    return modelNames;
  }

  void _selectDomain(BuildContext context, Domain domain) {
    context.read<DomainSelectionBloc>().add(SelectDomainEvent(domain));
  }
}
