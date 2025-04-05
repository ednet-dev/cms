# EDNet One Merge

This file documents the merger of `apps/one` content into `packages/ednet_one_interpreter`.

## Merge Details

- **Date**: April 5, 2023
- **Source**: `/Users/slavisam/projects/cms/apps/one`
- **Destination**: `/Users/slavisam/projects/cms/packages/ednet_one_interpreter`

## Changes Made

1. Copied all lib content from `apps/one` to `ednet_one_interpreter`
2. Copied test files from `apps/one/test` to `ednet_one_interpreter/test`
3. Updated `pubspec.yaml` to include all dependencies from the original `apps/one`
4. Updated `ednet_one_interpreter.dart` to export necessary components
5. Created backup of original lib content in `lib.bak/`
6. Copied assets directory
7. Fixed import paths to use `package:ednet_one_interpreter` instead of `package:ednet_one`
8. Fixed the DomainEvent name conflict by using `hide DomainEvent` in ednet_core imports
9. Copied documentation files (README.md, CONTRIBUTING.md, ROADMAP.md, DSL.md)
10. Copied doc/ directory
11. Copied pubspec_overrides.yaml
12. Copied platform-specific configurations:
    - android/
    - ios/
    - web/
    - macos/
    - linux/
    - windows/
13. Copied analysis_options.yaml

## Integration Notes

The integration combines the shell library functionality of `ednet_one_interpreter` with the full application from `apps/one`. This creates a single package that can be used both as a library and as a standalone application.

- The main application entry point is in `main.dart`
- The library entry point is `ednet_one_interpreter.dart`
- Original shell app functionality preserved in `src/` directory

## Next Steps

- [x] Fix import conflicts (e.g., the `DomainEvent` class name conflict)
- [x] Copy platform-specific configurations (android/, ios/, web/, etc.)
- [ ] Update README with new usage instructions
- [ ] Test the merged application
- [ ] Clean up any redundant or unused code
