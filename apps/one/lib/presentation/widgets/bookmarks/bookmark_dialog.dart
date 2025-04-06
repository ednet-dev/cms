import 'package:flutter/material.dart';
import 'bookmark_model.dart';

/// Dialog for creating or editing a bookmark
class BookmarkDialog extends StatefulWidget {
  /// The bookmark to edit (null for create mode)
  final Bookmark? bookmark;

  /// Constructor for BookmarkDialog
  const BookmarkDialog({super.key, this.bookmark});

  @override
  State<BookmarkDialog> createState() => _BookmarkDialogState();
}

class _BookmarkDialogState extends State<BookmarkDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _descriptionController;
  late BookmarkCategory _selectedCategory;

  @override
  void initState() {
    super.initState();

    // Initialize with values from bookmark if editing
    final bookmark = widget.bookmark;
    _titleController = TextEditingController(text: bookmark?.title ?? '');
    _urlController = TextEditingController(text: bookmark?.url ?? '');
    _descriptionController = TextEditingController(
      text: bookmark?.description ?? '',
    );
    _selectedCategory = bookmark?.category ?? BookmarkCategory.general;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditMode = widget.bookmark != null;

    return AlertDialog(
      title: Text(isEditMode ? 'Edit Bookmark' : 'Add Bookmark'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title for this bookmark',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),

            // URL field
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL/Path',
                hintText: 'Enter the path or URL',
              ),
              readOnly:
                  isEditMode, // Don't allow URL editing for existing bookmarks
            ),
            const SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter a description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<BookmarkCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items:
                  BookmarkCategory.values.map((category) {
                    return DropdownMenuItem<BookmarkCategory>(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 18),
                          const SizedBox(width: 8),
                          Text(category.displayName),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Validate inputs
            if (_titleController.text.trim().isEmpty ||
                _urlController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Title and URL are required')),
              );
              return;
            }

            // Create bookmark object
            final bookmark = Bookmark(
              id: widget.bookmark?.id, // Use existing ID or generate a new one
              title: _titleController.text.trim(),
              url: _urlController.text.trim(),
              description:
                  _descriptionController.text.trim().isNotEmpty
                      ? _descriptionController.text.trim()
                      : null,
              category: _selectedCategory,
              // Preserve other properties if editing
              domain: widget.bookmark?.domain,
              model: widget.bookmark?.model,
              concept: widget.bookmark?.concept,
              entity: widget.bookmark?.entity,
              icon: widget.bookmark?.icon,
              createdAt: widget.bookmark?.createdAt,
            );

            // Return the bookmark
            Navigator.of(context).pop(bookmark);
          },
          child: Text(isEditMode ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

/// Show a dialog to create or edit a bookmark
Future<Bookmark?> showBookmarkDialog(
  BuildContext context, {
  Bookmark? bookmarkToEdit,
}) async {
  return showDialog<Bookmark>(
    context: context,
    builder: (context) => BookmarkDialog(bookmark: bookmarkToEdit),
  );
}
