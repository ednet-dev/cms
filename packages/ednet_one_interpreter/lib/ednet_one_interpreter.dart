/// A Flutter package for interpreting domain models expressed in ednet_core.
///
/// This package provides shell app functionality for interpreting and displaying
/// domain models defined in ednet_core. It serves as a bridge between ednet_one
/// and ednet_cms, allowing for the interpretation and visualization of domain models.
library ednet_one_interpreter;

// Export original files
export 'shell_app.dart';
export 'presentation/widgets/widgets.dart';

// Export merged files from EDNet One
export 'presentation/blocs/domain_block.dart';
export 'presentation/blocs/domain_event.dart';
export 'presentation/blocs/domain_state.dart';
export 'presentation/blocs/layout_block.dart';
export 'presentation/blocs/theme_block.dart';
export 'presentation/screens/home_page.dart';
export 'main.dart';
