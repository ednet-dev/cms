// This file is part of the EDNetFlow library.
// Restored imports for source file organization.

import 'package:flutter/material.dart';




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
  dynamic render(
    EventStormingBoard board, {
    Map<String, dynamic> options = const {},
  });
}

/// Renders an Event Storming board as SVG.
///
/// This implementation produces an SVG representation of the board
/// that can be displayed in a browser or saved to a file.
class SvgBoardRenderer implements BoardRenderer {
  @override
  String render(
    EventStormingBoard board, {
    Map<String, dynamic> options = const {},
  }) {
    final width = options['width'] as int? ?? 1000;
    final height = options['height'] as int? ?? 800;
    final padding = options['padding'] as int? ?? 20;
    final showConnections = options['showConnections'] as bool? ?? true;

    // Start building SVG
    final buffer = StringBuffer();
    buffer.writeln(
      '<svg width="$width" height="$height" xmlns="http://www.w3.org/2000/svg">',
    );
    buffer.writeln('<rect width="$width" height="$height" fill="#f5f5f5" />');
    buffer.writeln('<g id="board" transform="translate($padding, $padding)">');

    // Add board title
    buffer.writeln(
      '<text x="${width / 2 - padding}" y="20" font-family="Arial" font-size="16" text-anchor="middle" font-weight="bold">',
    );
    buffer.writeln('${_escapeXml(board.name)} - Event Storming Board');
    buffer.writeln('</text>');

    // Add all elements
    if (showConnections) {
      _renderConnections(buffer, board);
    }

    _renderElements(buffer, board);

    // Close groups and SVG
    buffer.writeln('</g>');
    buffer.writeln('</svg>');

    return buffer.toString();
  }

  /// Renders all connections between elements
  void _renderConnections(StringBuffer buffer, EventStormingBoard board) {
    buffer.writeln('<g id="connections">');

    // Here we would need to extract and render connections between elements
    // This is a simplified placeholder - in a real implementation, we'd need to:
    // 1. Extract connections from the elements (or store them separately on the board)
    // 2. Render appropriate SVG lines/arrows between the elements

    buffer.writeln('</g>');
  }

  /// Renders all elements on the board
  void _renderElements(StringBuffer buffer, EventStormingBoard board) {
    // Domain Events
    buffer.writeln('<g id="events">');
    for (final event in board.domainEvents.values) {
      _renderElement(buffer, event, 'event');
    }
    buffer.writeln('</g>');

    // Commands
    buffer.writeln('<g id="commands">');
    for (final command in board.commands.values) {
      _renderElement(buffer, command, 'command');
    }
    buffer.writeln('</g>');

    // Aggregates
    buffer.writeln('<g id="aggregates">');
    for (final aggregate in board.aggregates.values) {
      _renderElement(buffer, aggregate, 'aggregate');
    }
    buffer.writeln('</g>');

    // Policies
    buffer.writeln('<g id="policies">');
    for (final policy in board.policies.values) {
      _renderElement(buffer, policy, 'policy');
    }
    buffer.writeln('</g>');

    // External Systems
    buffer.writeln('<g id="externalSystems">');
    for (final system in board.externalSystems.values) {
      _renderElement(buffer, system, 'externalSystem');
    }
    buffer.writeln('</g>');

    // Hot Spots
    buffer.writeln('<g id="hotSpots">');
    for (final hotspot in board.hotSpots.values) {
      _renderElement(buffer, hotspot, 'hotspot');
    }
    buffer.writeln('</g>');

    // Read Models
    buffer.writeln('<g id="readModels">');
    for (final readModel in board.readModels.values) {
      _renderElement(buffer, readModel, 'readModel');
    }
    buffer.writeln('</g>');
  }

  /// Renders a single element on the board
  void _renderElement(
    StringBuffer buffer,
    EventStormingElement element,
    String type,
  ) {
    final x = element.position.x;
    final y = element.position.y;
    final width = 120;
    final height = 80;

    // Create a sticky note rectangle for the element
    buffer.writeln(
      '<g id="${type}_${element.id}" transform="translate($x, $y)">',
    );
    buffer.writeln(
      '<rect width="$width" height="$height" rx="5" ry="5" fill="${element.color}" stroke="#000" stroke-width="1" />',
    );

    // Add the element name
    buffer.writeln(
      '<text x="${width / 2}" y="20" font-family="Arial" font-size="12" text-anchor="middle" font-weight="bold">',
    );
    buffer.writeln('${_escapeXml(element.name)}');
    buffer.writeln('</text>');

    // Add a short description if available
    if (element.description.isNotEmpty) {
      buffer.writeln(
        '<text x="${width / 2}" y="40" font-family="Arial" font-size="10" text-anchor="middle">',
      );

      // Truncate description if too long
      final truncatedDesc =
          element.description.length > 30
              ? '${element.description.substring(0, 27)}...'
              : element.description;

      buffer.writeln('${_escapeXml(truncatedDesc)}');
      buffer.writeln('</text>');
    }

    buffer.writeln('</g>');
  }

  /// Escapes special XML characters to prevent issues in SVG
  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}

/// Renders an Event Storming board as HTML.
///
/// This implementation produces an HTML representation of the board
/// that can be displayed in a web application.
class HtmlBoardRenderer implements BoardRenderer {
  @override
  String render(
    EventStormingBoard board, {
    Map<String, dynamic> options = const {},
  }) {
    final width = options['width'] as int? ?? 1000;
    final height = options['height'] as int? ?? 800;
    final showConnections = options['showConnections'] as bool? ?? true;

    // Start building HTML
    final buffer = StringBuffer();
    buffer.writeln(
      '<div class="event-storming-board" style="width: ${width}px; height: ${height}px; background-color: #f5f5f5; position: relative;">',
    );

    // Add board title
    buffer.writeln(
      '<h2 style="text-align: center; padding-top: 20px;">${_escapeHtml(board.name)}</h2>',
    );

    // Render all elements
    for (final event in board.domainEvents.values) {
      _renderHtmlElement(buffer, event, 'event');
    }

    for (final command in board.commands.values) {
      _renderHtmlElement(buffer, command, 'command');
    }

    for (final aggregate in board.aggregates.values) {
      _renderHtmlElement(buffer, aggregate, 'aggregate');
    }

    for (final policy in board.policies.values) {
      _renderHtmlElement(buffer, policy, 'policy');
    }

    for (final system in board.externalSystems.values) {
      _renderHtmlElement(buffer, system, 'external-system');
    }

    for (final hotspot in board.hotSpots.values) {
      _renderHtmlElement(buffer, hotspot, 'hotspot');
    }

    for (final readModel in board.readModels.values) {
      _renderHtmlElement(buffer, readModel, 'read-model');
    }

    // Close the board div
    buffer.writeln('</div>');

    return buffer.toString();
  }

  /// Renders a single element as HTML
  void _renderHtmlElement(
    StringBuffer buffer,
    EventStormingElement element,
    String type,
  ) {
    final x = element.position.x;
    final y = element.position.y;

    buffer.writeln('''
      <div class="es-element es-$type" id="${type}_${element.id}" 
           style="position: absolute; left: ${x}px; top: ${y}px; width: 120px; height: 80px; 
                  background-color: ${element.color}; border: 1px solid #000; 
                  border-radius: 5px; padding: 5px; box-shadow: 2px 2px 5px rgba(0,0,0,0.2);">
        <div class="es-element-title" style="font-weight: bold; font-size: 14px; text-align: center; margin-bottom: 5px;">
          ${_escapeHtml(element.name)}
        </div>
        <div class="es-element-desc" style="font-size: 12px; overflow: hidden; text-overflow: ellipsis; max-height: 40px;">
          ${_escapeHtml(element.description)}
        </div>
      </div>
    ''');
  }

  /// Escapes special HTML characters
  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
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
