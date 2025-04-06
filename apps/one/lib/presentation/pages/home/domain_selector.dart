import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_event.dart';
import 'package:ednet_one/presentation/state/blocs/domain_selection/domain_selection_state.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_bloc.dart';
import 'package:ednet_one/presentation/state/blocs/model_selection/model_selection_event.dart';
import 'package:ednet_one/presentation/state/navigation_helper.dart';

/// A component for selecting domains in the application
class DomainSelector extends StatelessWidget {
  /// Optional callback when a domain is selected
  final Function(Domain)? onDomainSelected;

  /// Constructor for DomainSelector
  const DomainSelector({super.key, this.onDomainSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainSelectionBloc, DomainSelectionState>(
      builder: (context, domainState) {
        return Row(
          children: [
            for (var domain in domainState.allDomains)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _DomainButton(
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
                ),
              ),
          ],
        );
      },
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          domain.code,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
