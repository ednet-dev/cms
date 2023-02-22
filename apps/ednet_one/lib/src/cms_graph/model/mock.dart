import 'package:ednet_one/src/cms_graph/model/edge.dart';
import 'package:ednet_one/src/cms_graph/model/node.dart';
import 'package:flutter/material.dart';

final List<Node> nodesMock = [
  Node(
    id: '1',
    label: 'Node 1',
    size: 200,
    paint: Paint()..color = Colors.red,
    textStyle: const TextStyle(color: Colors.white),
    angle: 0,
  ),
  Node(
    id: '2',
    label: 'Node 2',
    size: 200,
    paint: Paint()..color = Colors.blue,
    textStyle: const TextStyle(color: Colors.white),
    angle: 45,
  ),
];

final edgesMock = [
  Edge(
    source: nodesMock[0],
    target: nodesMock[1],
    label: 'Edge 1',
    paint: Paint()..color = Colors.red,
    textStyle: const TextStyle(color: Colors.white),
  ),
];

List<Node> nodes = [
  Node(
    id: "1",
    label: "Citizen 1",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 0,
  ),
  Node(
    id: "2",
    label: "Citizen 2",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 3,
  ),
  Node(
    id: "3",
    label: "Citizen 3",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 45,
  ),
  Node(
    id: "4",
    label: "Citizen 4",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 90,
  ),
];

List<Edge> edges = [
  Edge(
      source: nodes[0],
      target: nodes[1],
      label: "Supports",
      paint: Paint()..color = Colors.red,
      textStyle: const TextStyle(color: Colors.white)),
  Edge(
      source: nodes[1],
      target: nodes[2],
      label: "Opposes",
      paint: Paint()..color = Colors.blue,
      textStyle: const TextStyle(color: Colors.white)),
  Edge(
      source: nodes[2],
      target: nodes[3],
      label: "Supports",
      paint: Paint()..color = Colors.red,
      textStyle: const TextStyle(color: Colors.white)),
];

List<Node> nodes2 = [
  Node(
    id: "1",
    label: "Individual 1",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 0,
  ),
  Node(
    id: "2",
    label: "Individual 2",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 3,
  ),
  Node(
    id: "3",
    label: "Individual 3",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 45,
  ),
  Node(
    id: "4",
    label: "Individual 4",
    size: 100.0,
    paint: Paint(),
    textStyle: const TextStyle(),
    angle: 90,
  ),
];

List<Edge> edges2 = [
  Edge(
      source: nodes[0],
      target: nodes[1],
      label: "Friendship",
      paint: Paint()..color = Colors.red,
      textStyle: const TextStyle(color: Colors.white)),
  Edge(
      source: nodes[1],
      target: nodes[2],
      label: "Acquaintance",
      paint: Paint()..color = Colors.blue,
      textStyle: const TextStyle(color: Colors.white)),
  Edge(
      source: nodes[2],
      target: nodes[3],
      label: "Collegues",
      paint: Paint()..color = Colors.red,
      textStyle: const TextStyle(color: Colors.white)),
];
