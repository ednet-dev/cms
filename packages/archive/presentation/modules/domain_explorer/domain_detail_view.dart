import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../presentation/theme/providers/theme_provider.dart';
import '../../../presentation/theme/extensions/theme_spacing.dart';
import '../../../presentation/widgets/semantic_concept_container.dart';
import '../../../presentation/state/blocs/model_selection/model_selection_bloc.dart';
import '../../../presentation/state/blocs/model_selection/model_selection_event.dart';
import '../../../presentation/state/blocs/model_selection/model_selection_state.dart';
import '../../../presentation/navigation/navigation_service.dart';

/// Displays detailed information about a domain and its models
class DomainDetailView extends StatefulWidget {
  /// The domain to display
  final Domain domain;

  const DomainDetailView({super.key, required this.domain});

  @override
  State<DomainDetailView> createState() => _DomainDetailViewState();
}

class _DomainDetailViewState extends State<DomainDetailView> {
  @override
  void initState() {
    super.initState();
    // Trigger model loading for this domain
    context.read<ModelSelectionBloc>().add(
      UpdateModelsForDomainEvent(widget.domain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'DomainDetail',
      child: Padding(
        padding: EdgeInsets.all(context.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain header section
            _buildDomainHeader(context),

            SizedBox(height: context.spacingL),

            // Models section
            _buildModelsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainHeader(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'DomainHeader',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(context.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.domain,
                    size: 32,
                    color: context.conceptColor('Domain', role: 'icon'),
                  ),
                  SizedBox(width: context.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.domain.code,
                          style: context.conceptTextStyle(
                            'Domain',
                            role: 'header',
                          ),
                        ),
                        SizedBox(height: context.spacingXs),
                        Text(
                          '${widget.domain.models.length} models',
                          style: context.conceptTextStyle(
                            'Domain',
                            role: 'subtitle',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.spacingM),

              // Domain metadata
              _buildMetadataSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    // In a real application, you'd extract and display domain metadata here
    return SemanticConceptContainer(
      conceptType: 'DomainMetadata',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Domain Properties',
            style: context.conceptTextStyle('DomainMetadata', role: 'title'),
          ),
          SizedBox(height: context.spacingS),
          _buildMetadataItem(context, 'Type', 'Domain'),
          _buildMetadataItem(
            context,
            'Created',
            'N/A', // In a real app, you'd use domain.whenAdded?.toString() ?? 'N/A'
          ),
          _buildMetadataItem(
            context,
            'Last Modified',
            'N/A', // In a real app, you'd use domain.whenSet?.toString() ?? 'N/A'
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: context.conceptTextStyle('DomainMetadata', role: 'label'),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.conceptTextStyle('DomainMetadata', role: 'value'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelsSection(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ModelSelectionBloc, ModelSelectionState>(
        builder: (context, state) {
          if (state.availableModels.isEmpty) {
            return Center(
              child: Text(
                'No models available for this domain',
                style: context.conceptTextStyle('Info'),
              ),
            );
          }

          return _buildModelsList(context, state.availableModels.toList());
        },
      ),
    );
  }

  Widget _buildModelsList(BuildContext context, List<Model> models) {
    return SemanticConceptContainer(
      conceptType: 'ModelList',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Models',
            style: context.conceptTextStyle('ModelList', role: 'title'),
          ),
          SizedBox(height: context.spacingM),
          Expanded(
            child: ListView.builder(
              itemCount: models.length,
              itemBuilder: (context, index) {
                return _buildModelCard(context, models[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelCard(BuildContext context, Model model) {
    return SemanticConceptContainer(
      conceptType: 'Model',
      child: Card(
        margin: EdgeInsets.only(bottom: context.spacingM),
        child: InkWell(
          onTap: () => _navigateToModel(context, model),
          child: Padding(
            padding: EdgeInsets.all(context.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.data_object,
                      color: context.conceptColor('Model', role: 'icon'),
                    ),
                    SizedBox(width: context.spacingS),
                    Expanded(
                      child: Text(
                        model.code,
                        style: context.conceptTextStyle('Model', role: 'title'),
                      ),
                    ),
                    Text(
                      '${model.concepts.length} concepts',
                      style: context.conceptTextStyle('Model', role: 'badge'),
                    ),
                  ],
                ),
                SizedBox(height: context.spacingS),
                Text(
                  'Contains entity types: ${_getTopConceptNames(model).join(", ")}',
                  style: context.conceptTextStyle('Model', role: 'description'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getTopConceptNames(Model model) {
    // Get up to 3 concept names for preview
    final conceptNames = <String>[];
    final concepts = model.concepts.toList();

    final count = concepts.length > 3 ? 3 : concepts.length;
    for (var i = 0; i < count; i++) {
      conceptNames.add(concepts[i].code);
    }

    if (concepts.length > 3) {
      conceptNames.add('...');
    }

    return conceptNames;
  }

  void _navigateToModel(BuildContext context, Model model) {
    // Select the model
    context.read<ModelSelectionBloc>().add(SelectModelEvent(model));

    // Navigate to the Models module
    final navigationService = Provider.of<NavigationService>(
      context,
      listen: false,
    );
    navigationService.navigateToModule('models');
  }
}
