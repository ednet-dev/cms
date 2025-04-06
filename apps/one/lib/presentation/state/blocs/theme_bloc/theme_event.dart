
/// Base class for all theme events
abstract class ThemeEvent {}

/// Event to initialize the theme
class InitializeThemeEvent extends ThemeEvent {}

/// Event to toggle between light and dark mode
class ToggleThemeEvent extends ThemeEvent {}

/// Event to change to a specific theme
class ChangeThemeEvent extends ThemeEvent {
  /// The name of the theme to change to
  final String themeName;

  /// Creates a new change theme event with the specified theme name
  ChangeThemeEvent(this.themeName);
}
