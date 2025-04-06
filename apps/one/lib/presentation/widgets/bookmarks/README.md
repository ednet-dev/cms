# Bookmark System

This directory contains components that implement a persistent bookmark system for the EDNet One application.

## Components

### Models

- **Bookmark**: Represents a bookmark with title, URL, category, and metadata.
- **BookmarkCategory**: Enum defining different categories for organizing bookmarks.

### UI Components

- **BookmarkItem**: Individual bookmark entry with click/edit/delete functionality.
- **BookmarkCategorySection**: Groups bookmarks by category.
- **BookmarkDialog**: Dialog for creating and editing bookmarks.
- **BookmarkSidebar**: Side panel for accessing bookmarks.
- **BookmarksScreen**: Full-page bookmark management.

### State Management

- **BookmarkManager**: Service that manages bookmark state and persistence with SharedPreferences.

## Persistence

Bookmarks are automatically persisted to SharedPreferences whenever:
- A bookmark is added
- A bookmark is updated
- A bookmark is deleted
- Bookmarks are imported

## Usage

1. Access the shared BookmarkManager through the Provider:

```dart
final bookmarkManager = Provider.of<BookmarkManager>(context, listen: false);
```

2. Create and save a bookmark:

```dart
final bookmark = Bookmark(
  title: 'My Bookmark',
  url: '/path/to/resource',
  category: BookmarkCategory.entity,
);
await bookmarkManager.addBookmark(bookmark);
```

3. Display bookmarks using the BookmarkSidebar:

```dart
Scaffold(
  drawer: BookmarkSidebar(),
  // Rest of your app
)
```

4. Load and access bookmarks:

```dart
// Get all bookmarks
final bookmarks = await bookmarkManager.getBookmarks();

// Get bookmarks by category
final favorites = await bookmarkManager.getBookmarksByCategory(BookmarkCategory.favorite);

// Search bookmarks
final results = await bookmarkManager.searchBookmarks('search term');
```

## Global Access

The BookmarkManager is provided globally through the `AppBlocProviders` class, making it accessible from anywhere in the application. 