part of ednet_core_flutter;

/// Extension methods for ShellApp to provide advanced UI features
/// These methods enable quick access to features like domain model diffing,
/// meta model editing, and canvas visualization.
extension AdvancedShellAppFeatures on ShellApp {
  /// Shows the domain model diffing dialog
  void showDomainModelDiffing(BuildContext context) {
    if (!hasFeature('domain_model_diffing')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Domain model diffing is not enabled')),
      );
      return;
    }

    // Get the current diff
    final diff = exportDomainModelDiff(domain.code);

    // Show the diff in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Domain Model Diff'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              diff.isEmpty ? 'No changes detected' : diff,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Save the diff to a file
              final success = await saveDomainModelDiffToFile(
                domain.code,
                'domain_diff_${DateTime.now().millisecondsSinceEpoch}.json',
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Domain model diff saved successfully'),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
          if (isMultiDomain)
            ElevatedButton(
              onPressed: () => _showMultiDomainDiffSelector(context),
              child: const Text('All Domains'),
            ),
        ],
      ),
    );
  }

  /// Shows a selector for diffing multiple domains
  void _showMultiDomainDiffSelector(BuildContext context) {
    if (!isMultiDomain) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Domain to Diff'),
        content: SizedBox(
          width: 400,
          height: 300,
          child: ListView.builder(
            itemCount: domains.length,
            itemBuilder: (context, index) {
              final domain = domains[index];
              return ListTile(
                title: Text(domain.code),
                subtitle: Text('${domain.models.length} models'),
                onTap: () {
                  Navigator.pop(context);
                  _showDomainDiffByIndex(context, index);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _showAllDomainsDiff(context),
            child: const Text('Show All Diffs'),
          ),
        ],
      ),
    );
  }

  /// Shows diff for a specific domain by index
  void _showDomainDiffByIndex(BuildContext context, int domainIndex) {
    final domain = domains[domainIndex];
    final diff = exportDomainModelDiffByIndex(domainIndex);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Domain Diff: ${domain.code}'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              diff.isEmpty ? 'No changes detected' : diff,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await saveDomainModelDiffToFile(
                domain.code,
                'domain_diff_${domain.code}_${DateTime.now().millisecondsSinceEpoch}.json',
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${domain.code} diff saved successfully'),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Shows diffs for all domains
  void _showAllDomainsDiff(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Domain Diffs'),
        content: SizedBox(
          width: 700,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < domains.length; i++) ...[
                  Text(
                    domains[i].code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Divider(),
                  SelectableText(
                    exportDomainModelDiffByIndex(i).isEmpty
                        ? 'No changes'
                        : exportDomainModelDiffByIndex(i),
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Create a combined diff file for all domains
              bool success = true;
              for (var i = 0; i < domains.length; i++) {
                final domain = domains[i];
                final result = await saveDomainModelDiffToFile(
                  domain.code,
                  'all_domains_diff_${domain.code}_${DateTime.now().millisecondsSinceEpoch}.json',
                );
                success = success && result;
              }

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All domain diffs saved successfully'),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save All'),
          ),
        ],
      ),
    );
  }

  /// Shows the meta model editor dialog
  void showMetaModelEditor(BuildContext context, {Concept? concept}) {
    if (!hasFeature(ShellConfiguration.metaModelEditingFeature)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meta model editing is not enabled')),
      );
      return;
    }

    // Navigate to the meta model editor instead of showing a dialog
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MetaModelEditor(
          shellApp: this,
          domain: domain,
          concept: concept,
          initialViewMode: EntityViewMode.cards, // Use card mode by default
          enableLiveEditing: true,
        ),
      ),
    );
  }

  /// Shows a canvas visualization of the domain model
  void showDomainModelCanvas(BuildContext context) {
    if (!hasFeature('canvas_visualization')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Canvas visualization is not enabled')),
      );
      return;
    }

    // Navigate to a canvas view that would be implemented in a real app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Domain model canvas coming soon')),
    );
  }

  /// Apply changes from a domain model diff
  Future<bool> applyDomainModelDiff(
      BuildContext context, String jsonDiff) async {
    if (!hasFeature('domain_model_diffing')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Domain model diffing is not enabled')),
      );
      return false;
    }

    try {
      // Apply the diff to the domain model
      final success = await importDomainModelDiff(domain.code, jsonDiff);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Domain model changes applied successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to apply domain model changes')),
        );
      }

      return success;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying domain model changes: $e')),
      );
      return false;
    }
  }
}
