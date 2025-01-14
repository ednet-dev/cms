import 'dart:math';

import 'package:ednet_core/ednet_core.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class GraphLayout {
  final Domains domains;
  final double defaultNodeWidth = 400;
  final double defaultNodeHeight = 600;

  GraphLayout({required this.domains});

  Graph buildGraph() {
    final graph = Graph();
    final domainNodes = <String, Node>{};

    for (var domain in domains) {
      final domainNode = Node.Id(domain.code);
      domainNodes[domain.code] = domainNode;
      graph.addNode(domainNode);

      for (var model in domain.models) {
        final modelNode = Node.Id(model.code);
        graph.addNode(modelNode);
        graph.addEdge(domainNode, modelNode);

        for (var entity in model.concepts) {
          final entityNode = Node.Id(entity.code);
          graph.addNode(entityNode);
          graph.addEdge(modelNode, entityNode);

          for (var attribute in entity.attributes) {
            final attributeNode = Node.Id(attribute.code);
            graph.addNode(attributeNode);
            graph.addEdge(entityNode, attributeNode);
          }

          for (var child in entity.children) {
            final childNode = Node.Id(child.code);
            graph.addNode(childNode);
            graph.addEdge(entityNode, childNode);
          }
        }
      }
    }
    return graph;
  }

  bool checkForCycles(Graph graph) {
    final visited = <Node>{};
    final stack = <Node>{};

    bool hasCycle(Node node) {
      if (stack.contains(node)) return true;
      if (visited.contains(node)) return false;
      visited.add(node);
      stack.add(node);

      for (final neighbor in graph.successorsOf(node)) {
        if (hasCycle(neighbor)) return true;
      }
      stack.remove(node);
      return false;
    }

    for (final node in graph.nodes) {
      if (hasCycle(node)) {
        return true;
      }
    }
    return false;
  }

  Map<String, Offset> calculateLayout(Size size) {
    final positions = <String, Offset>{};
    final random = Random();

    for (var domain in domains) {
      positions[domain.code] = Offset(
        random.nextDouble() * (size.width - defaultNodeWidth),
        random.nextDouble() * (size.height - defaultNodeHeight),
      );

      for (var model in domain.models) {
        positions[model.code] = Offset(
          random.nextDouble() * (size.width - defaultNodeWidth),
          random.nextDouble() * (size.height - defaultNodeHeight),
        );

        for (var entity in model.concepts) {
          positions[entity.code] = Offset(
            random.nextDouble() * (size.width - defaultNodeWidth),
            random.nextDouble() * (size.height - defaultNodeHeight),
          );

          for (var attribute in entity.attributes) {
            positions[attribute.code] = Offset(
              random.nextDouble() * (size.width - defaultNodeWidth),
              random.nextDouble() * (size.height - defaultNodeHeight),
            );
          }

          for (var child in entity.children) {
            positions[child.code] = Offset(
              random.nextDouble() * (size.width - defaultNodeWidth),
              random.nextDouble() * (size.height - defaultNodeHeight),
            );
          }
        }
      }
    }

    return positions;
  }
}
