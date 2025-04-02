import '../session/event_storming_board.dart';

/// Interface for rendering an Event Storming board.
///
/// This interface defines the contract for classes that render
/// an event storming board in various formats (SVG, HTML, etc.).
abstract class BoardRenderer {
  /// Renders the board in a specific format.
  ///
  /// The output format depends on the implementing class.
  ///
  /// Parameters:
  /// - [board]: The event storming board to render
  /// - [options]: Optional rendering options
  ///
  /// Returns:
  /// A representation of the rendered board
  dynamic render(EventStormingBoard board, {Map<String, dynamic> options = const {}});
}

/// Renders an Event Storming board as SVG.
///
/// This implementation produces an SVG representation of the board
/// that can be displayed in a browser or saved to a file.
class SvgBoardRenderer implements BoardRenderer {
  @override
  String render(EventStormingBoard board, {Map<String, dynamic> options = const {}}) {
    // This is a placeholder implementation
    // A full implementation would build an SVG representation of the board
    return '''
      <svg width="1000" height="800" xmlns="http://www.w3.org/2000/svg">
        <rect width="1000" height="800" fill="#f5f5f5" />
        <text x="500" y="400" font-family="Arial" font-size="24" text-anchor="middle">
          ${board.name} - Event Storming Board
        </text>
        <!-- Additional elements would be added here -->
      </svg>
    ''';
  }
}

/// Renders an Event Storming board as HTML.
///
/// This implementation produces an HTML representation of the board
/// that can be displayed in a web application.
class HtmlBoardRenderer implements BoardRenderer {
  @override
  String render(EventStormingBoard board, {Map<String, dynamic> options = const {}}) {
    // This is a placeholder implementation
    // A full implementation would build an HTML representation of the board
    return '''
      <div class="event-storming-board" style="width: 1000px; height: 800px; background-color: #f5f5f5;">
        <h2 style="text-align: center; padding-top: 20px;">${board.name}</h2>
        <!-- Additional elements would be added here -->
      </div>
    ''';
  }
}

/// Factory for creating board renderers.
///
/// This factory provides a convenient way to create the appropriate
/// renderer based on the desired output format.
class BoardRendererFactory {
  /// Creates a renderer for the specified format.
  ///
  /// Parameters:
  /// - [format]: The desired output format ('svg', 'html', etc.)
  ///
  /// Returns:
  /// A renderer for the specified format
  ///
  /// Throws:
  /// ArgumentError if the format is not supported
  static BoardRenderer createRenderer(String format) {
    switch (format.toLowerCase()) {
      case 'svg':
        return SvgBoardRenderer();
      case 'html':
        return HtmlBoardRenderer();
      default:
        throw ArgumentError('Unsupported format: $format');
    }
  }
} 