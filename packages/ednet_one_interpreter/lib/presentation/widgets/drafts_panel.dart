import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ednet_core/ednet_core.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_block.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_event.dart';
import 'package:ednet_one_interpreter/presentation/blocs/domain_state.dart';

/// A widget that displays drafts and version history for domain models.
///
/// This widget provides UI for managing drafts, versions, and model changes.
class DraftsPanel extends StatelessWidget {
  /// Creates a new [DraftsPanel].
  const DraftsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DomainBloc, DomainState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, state),
                const Divider(),
                if (state.isDomainModelChanged)
                  _buildUnsavedChanges(context, state),
                if (state.hasDraftForCurrentModel)
                  _buildDraftSection(context, state),
                _buildVersionsSection(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DomainState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Model Changes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: () {
            context.read<DomainBloc>().add(ListDraftsEvent());
            if (state.selectedDomain != null && state.selectedModel != null) {
              context.read<DomainBloc>().add(
                ListVersionsEvent(
                  domainCode: state.selectedDomain!.codeFirstLetterLower,
                  modelCode: state.selectedModel!.codeFirstLetterLower,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildUnsavedChanges(BuildContext context, DomainState state) {
    if (state.selectedDomain == null || state.selectedModel == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.amber.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Unsaved Changes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'You have unsaved changes to this model.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Draft'),
                  onPressed: () {
                    context.read<DomainBloc>().add(
                      SaveDraftEvent(
                        domain: state.selectedDomain!,
                        model: state.selectedModel!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftSection(BuildContext context, DomainState state) {
    if (state.selectedDomain == null || state.selectedModel == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.drafts, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Draft Available',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'You have a saved draft for this model.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('Load'),
                  onPressed: () {
                    context.read<DomainBloc>().add(
                      LoadDraftEvent(
                        domainCode: state.selectedDomain!.codeFirstLetterLower,
                        modelCode: state.selectedModel!.codeFirstLetterLower,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Commit'),
                  onPressed: () {
                    context.read<DomainBloc>().add(
                      CommitDraftEvent(
                        domainCode: state.selectedDomain!.codeFirstLetterLower,
                        modelCode: state.selectedModel!.codeFirstLetterLower,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Discard'),
                  onPressed: () {
                    _showDiscardConfirmation(
                      context,
                      state.selectedDomain!.codeFirstLetterLower,
                      state.selectedModel!.codeFirstLetterLower,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionsSection(BuildContext context, DomainState state) {
    if (state.selectedDomain == null || state.selectedModel == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'Select a domain and model to view version history',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        ),
      );
    }

    if (state.availableVersions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'No version history available for this model',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Version History',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: state.availableVersions.length,
            itemBuilder: (context, index) {
              final version = state.availableVersions[index];
              final timestamp = DateTime.fromMillisecondsSinceEpoch(
                int.parse(version),
              );
              final isSelected = version == state.currentVersionTimestamp;

              return ListTile(
                selected: isSelected,
                selectedTileColor: Colors.blue.shade50,
                leading: const Icon(Icons.history),
                title: Text(
                  'Version ${index + 1}',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  'Created on ${_formatDate(timestamp)}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.restore),
                  tooltip: 'Restore this version',
                  onPressed: () {
                    context.read<DomainBloc>().add(
                      LoadVersionEvent(
                        domainCode: state.selectedDomain!.codeFirstLetterLower,
                        modelCode: state.selectedModel!.codeFirstLetterLower,
                        versionTimestamp: version,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDiscardConfirmation(
    BuildContext context,
    String domainCode,
    String modelCode,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard Draft?'),
          content: const Text(
            'Are you sure you want to discard this draft? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<DomainBloc>().add(
                  DiscardDraftEvent(
                    domainCode: domainCode,
                    modelCode: modelCode,
                  ),
                );
              },
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
