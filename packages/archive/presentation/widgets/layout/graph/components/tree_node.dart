import 'dart:ui';

class TreeNode {
  String key;
  Offset position;
  TreeNode? left;
  TreeNode? right;
  int height;
  List<TreeNode> children;

  TreeNode(this.key, this.position) : height = 1, children = [];
}
