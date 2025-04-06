import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';
import 'package:ednet_one/presentation/widgets/semantic_concept_container.dart';
import 'package:ednet_one/presentation/theme/providers/theme_provider.dart';
import 'package:ednet_one/presentation/theme/extensions/theme_spacing.dart';

/// A component for selecting domains in the application
///
/// Follows the Holy Trinity architecture by using semantic concept containers
/// and applying theme styling based on domain concepts.
class DomainSelector extends StatelessWidget {
  /// Optional callback when a domain is selected
  final Function(Domain)? onDomainSelected;

  /// Constructor for DomainSelector
  const DomainSelector({super.key, this.onDomainSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, domainState) {
        // Use SemanticConceptContainer to wrap the domain selector
        return SemanticConceptContainer(
          conceptType: 'DomainSelector',
          child: LayoutBuilder(
            builder: (context, constraints) {
              // If we have limited width, switch to a dropdown instead of buttons
              final bool useDropdown = constraints.maxWidth < 500;

              if (useDropdown) {
                return _buildDomainDropdown(context, domainState);
              } else {
                return _buildDomainButtons(context, domainState);
              }
            },
          ),
        );
      },
    );
  }

  /// Builds a row of domain buttons for wider displays
  Widget _buildDomainButtons(
    BuildContext context,
    DomainSelectionState domainState,
  ) {
    return SemanticFlowContainer(
      spacing: context.spacingS,
      runSpacing: context.spacingXs,
      children:
          domainState.availableDomains.map((domain) {
            return _DomainButton(
              domain: domain,
              isSelected: domain == domainState.selectedDomain,
              onTap: () {
                // Use the centralized navigation helper
                NavigationHelper.navigateToDomain(context, domain);

                // Call optional callback
                if (onDomainSelected != null) {
                  onDomainSelected!(domain);
                }
              },
            );
          }).toList(),
    );
  }

  /// Builds a dropdown for domain selection on narrow displays
  Widget _buildDomainDropdown(
    BuildContext context,
    DomainSelectionState domainState,
  ) {
    // If no domains are available, show an empty container
    if (domainState.availableDomains.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(context.spacingXs),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.conceptColor('Domain', role: 'border'),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<Domain>(
        value: domainState.selectedDomain ?? domainState.availableDomains.first,
        underline: const SizedBox.shrink(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: context.conceptColor('Domain'),
        ),
        isExpanded: true,
        onChanged: (Domain? newValue) {
          if (newValue != null) {
            NavigationHelper.navigateToDomain(context, newValue);

            if (onDomainSelected != null) {
              onDomainSelected!(newValue);
            }
          }
        },
        items:
            domainState.availableDomains.map((Domain domain) {
              return DropdownMenuItem<Domain>(
                value: domain,
                child: Text(
                  domain.code,
                  style: context.conceptTextStyle('Domain', role: 'title'),
                ),
              );
            }).toList(),
      ),
    );
  }
}

/// Internal widget for rendering a selectable domain button
class _DomainButton extends StatelessWidget {
  final Domain domain;
  final bool isSelected;
  final VoidCallback onTap;

  const _DomainButton({
    required this.domain,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SemanticConceptContainer(
      conceptType: 'Domain',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacingM,
            vertical: context.spacingXs,
          ),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? context.conceptColor('Domain', role: 'selectedBackground')
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color:
                  isSelected
                      ? context.conceptColor('Domain', role: 'selected')
                      : context.conceptColor('Domain', role: 'border'),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Text(
            domain.code,
            style:
                isSelected
                    ? context.conceptTextStyle('Domain', role: 'selected')
                    : context.conceptTextStyle('Domain', role: 'default'),
          ),
        ),
      ),
    );
  }
}
