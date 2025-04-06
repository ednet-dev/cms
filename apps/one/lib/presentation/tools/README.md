# EDNet One Presentation Layer Cleanup Tools

This directory contains utility scripts for cleaning up and maintaining the presentation layer codebase.

## Available Tools

### run_cleanup.sh

The main shell script that orchestrates all the cleanup utilities in a single command.

**Usage:**
```bash
./run_cleanup.sh [--dry-run]
```

Options:
- `--dry-run`: Run in dry-run mode (shows changes without making them)

### fix_unused_imports.dart

Identifies and removes unused imports from Dart files.

**Usage:**
```bash
dart fix_unused_imports.dart [--dry-run] [--dir=<directory>]
```

Options:
- `--dry-run`: Show unused imports without removing them
- `--dir`: Specify a subdirectory to scan (default: entire presentation layer)

### update_material_apis.dart

Updates deprecated Material Design API calls to their modern equivalents.

**Usage:**
```bash
dart update_material_apis.dart [--dry-run] [--dir=<directory>]
```

Options:
- `--dry-run`: Show API updates without applying them
- `--dir`: Specify a subdirectory to scan (default: entire presentation layer)

### fix_opacity_api.dart

Updates deprecated `withOpacity()` calls to use the newer `withValues()` API.

**Usage:**
```bash
dart fix_opacity_api.dart [--dry-run] [--dir=<directory>]
```

Options:
- `--dry-run`: Show opacity API updates without applying them
- `--dir`: Specify a subdirectory to scan (default: entire presentation layer)

### fix_unused_variables.dart

Identifies and comments out unused variables to resolve analyzer warnings.

**Usage:**
```bash
dart fix_unused_variables.dart [--dry-run] [--dir=<directory>]
```

Options:
- `--dry-run`: Show unused variables without modifying them
- `--dir`: Specify a subdirectory to scan (default: entire presentation layer)

### fix_bloc_warnings.dart

Fixes BLoC-related warnings such as invalid emit calls and incorrect @override annotations.

**Usage:**
```bash
dart fix_bloc_warnings.dart [--dry-run] [--dir=<directory>]
```

Options:
- `--dry-run`: Show BLoC issues without modifying them
- `--dir`: Specify a subdirectory to scan (default: entire presentation layer)

### fix_dead_code.dart

Identifies and comments out dead code blocks in service classes.

**Usage:**
```bash
dart fix_dead_code.dart [--dry-run] [--dir=<directory>]
```

Options:
- `--dry-run`: Show dead code issues without modifying them
- `--dir`: Specify a subdirectory to scan (default: entire presentation layer)

## Development Notes

- These tools were created as part of the presentation layer migration and refactoring effort
- All tools support a dry-run mode for previewing changes before application
- The scripts automatically run Dart analyzer after making changes to verify improvements
- Excluded from production builds - these are development utilities only

## Known Limitations

1. These tools use simple regex-based detection and may not catch all cases
2. The tools do not modify imports in `.g.dart` files or other generated code
3. For complex cases, manual review is recommended after tool execution

## Future Improvements

- Add logging instead of print statements
- Add unit tests for the tools themselves
- Integrate with the Dart analyzer API for more accurate detection
- Add support for batch processing of files 