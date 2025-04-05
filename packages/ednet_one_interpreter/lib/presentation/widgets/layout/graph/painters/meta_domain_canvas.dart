import 'package:flutter/material.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../../../../domain_model_visualization/domain_model_visualization.dart';
import '../algorithms/master_detail_layout_algorithm.dart';

/// An extension method to convert a Domain to a Domains collection.
extension DomainToDomainsExtension on Domain {
  Domains toDomains() {
    final ds = Domains();
    ds.add(this);
    return ds;
  }
}

/// A custom decorator for domain graph elements
abstract class DomainGraphDecorator {
  /// Apply decoration to a concept node
  Widget decorateConcept(BuildContext context, Concept concept, Widget child);

  /// Apply decoration to a relationship edge
  CustomPaint decorateRelationship(
    BuildContext context,
    Property relationship,
    CustomPaint child,
  );
}

/// A canvas widget for visualizing domain models at a meta level.
///
/// This widget provides an interactive canvas for working with domain models,
/// showing concepts, their relationships, and allowing interaction.
class MetaDomainCanvas extends StatefulWidget {
  /// The domains to visualize
  final Domains domains;

  /// The initial transformation matrix
  final Matrix4? initialTransformation;

  /// Callback for when the transformation changes
  final Function(Matrix4)? onTransformationChanged;

  /// Callback for when the layout algorithm changes
  final Function(dynamic)? onChangeLayoutAlgorithm;

  /// The layout algorithm to use
  final MasterDetailLayoutAlgorithm layoutAlgorithm;

  /// Optional decorators for graph elements
  final List<DomainGraphDecorator> decorators;

  /// Creates a new meta domain canvas.
  const MetaDomainCanvas({
    Key? key,
    required this.domains,
    this.initialTransformation,
    this.onTransformationChanged,
    this.onChangeLayoutAlgorithm,
    required this.layoutAlgorithm,
    this.decorators = const [],
  }) : super(key: key);

  @override
  _MetaDomainCanvasState createState() => _MetaDomainCanvasState();
}

class _MetaDomainCanvasState extends State<MetaDomainCanvas> {
  late TransformationController _transformationController;
  late Model? _selectedModel;
  late Domain? _selectedDomain;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    if (widget.initialTransformation != null) {
      _transformationController.value = widget.initialTransformation!;
    }

    _selectedDomain = widget.domains.isNotEmpty ? widget.domains.first : null;
    _selectedModel =
        _selectedDomain?.models.isNotEmpty == true
            ? _selectedDomain!.models.first
            : null;
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.domains.isEmpty) {
      return const Center(child: Text('No domains to visualize'));
    }

    return Column(
      children: [_buildControlPanel(), Expanded(child: _buildCanvas())],
    );
  }

  /// Builds the control panel with domain and model selection.
  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Domain selector
          DropdownButton<Domain>(
            value: _selectedDomain,
            hint: const Text('Select a domain'),
            onChanged: (Domain? domain) {
              if (domain != null) {
                setState(() {
                  _selectedDomain = domain;
                  _selectedModel =
                      domain.models.isNotEmpty ? domain.models.first : null;
                });
              }
            },
            items:
                widget.domains.map((domain) {
                  return DropdownMenuItem<Domain>(
                    value: domain,
                    child: Text(domain.code),
                  );
                }).toList(),
          ),

          const SizedBox(width: 16),

          // Model selector (if domain is selected)
          if (_selectedDomain != null)
            DropdownButton<Model>(
              value: _selectedModel,
              hint: const Text('Select a model'),
              onChanged: (Model? model) {
                if (model != null) {
                  setState(() {
                    _selectedModel = model;
                  });
                }
              },
              items:
                  _selectedDomain!.models.map((model) {
                    return DropdownMenuItem<Model>(
                      value: model,
                      child: Text(model.code),
                    );
                  }).toList(),
            ),

          const Spacer(),

          // Zoom controls
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              setState(() {
                final scale =
                    _transformationController.value.getMaxScaleOnAxis();
                final newScale = scale * 1.2;
                _transformationController.value = Matrix4.diagonal3Values(
                  newScale,
                  newScale,
                  1,
                );

                if (widget.onTransformationChanged != null) {
                  widget.onTransformationChanged!(
                    _transformationController.value,
                  );
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              setState(() {
                final scale =
                    _transformationController.value.getMaxScaleOnAxis();
                final newScale = scale / 1.2;
                _transformationController.value = Matrix4.diagonal3Values(
                  newScale,
                  newScale,
                  1,
                );

                if (widget.onTransformationChanged != null) {
                  widget.onTransformationChanged!(
                    _transformationController.value,
                  );
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              setState(() {
                _transformationController.value = Matrix4.identity();

                if (widget.onTransformationChanged != null) {
                  widget.onTransformationChanged!(
                    _transformationController.value,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  /// Builds the interactive canvas with the domain visualization.
  Widget _buildCanvas() {
    if (_selectedDomain == null) {
      return const Center(child: Text('Please select a domain'));
    }

    if (_selectedModel == null) {
      return const Center(child: Text('Please select a model'));
    }

    return InteractiveViewer(
      transformationController: _transformationController,
      boundaryMargin: const EdgeInsets.all(1000),
      minScale: 0.1,
      maxScale: 5.0,
      onInteractionEnd: (ScaleEndDetails details) {
        if (widget.onTransformationChanged != null) {
          widget.onTransformationChanged!(_transformationController.value);
        }
      },
      child: Center(
        child: SizedBox(
          width: 2000, // Large canvas size
          height: 2000,
          child: DomainModelVisualization(
            domain: _selectedDomain!,
            model: _selectedModel!,
          ),
        ),
      ),
    );
  }
}
