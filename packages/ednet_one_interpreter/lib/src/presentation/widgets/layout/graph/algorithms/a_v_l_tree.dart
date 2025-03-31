import 'dart:ui';

import '../components/tree_node.dart';

class AVLTree {
  TreeNode? root;

  int height(TreeNode? node) {
    return node?.height ?? 0;
  }

  int max(int a, int b) {
    return (a > b) ? a : b;
  }

  TreeNode? rightRotate(TreeNode y) {
    if (y.left == null) return y; // Added null check
    TreeNode x = y.left!;
    TreeNode? T2 = x.right;

    x.right = y;
    y.left = T2;

    y.height = max(height(y.left), height(y.right)) + 1;
    x.height = max(height(x.left), height(x.right)) + 1;

    return x;
  }

  TreeNode? leftRotate(TreeNode x) {
    if (x.right == null) return x; // Added null check
    TreeNode y = x.right!;
    TreeNode? T2 = y.left;

    y.left = x;
    x.right = T2;

    x.height = max(height(x.left), height(x.right)) + 1;
    y.height = max(height(y.left), height(y.right)) + 1;

    return y;
  }

  int getBalance(TreeNode? node) {
    if (node == null) return 0;
    return height(node.left) - height(node.right);
  }

  TreeNode insert(TreeNode? node, String key, Offset position) {
    if (node == null) return TreeNode(key, position);

    if (key.compareTo(node.key) < 0) {
      node.left = insert(node.left, key, position);
    } else if (key.compareTo(node.key) > 0) {
      node.right = insert(node.right, key, position);
    } else {
      return node;
    }

    node.height = max(height(node.left), height(node.right)) + 1;

    int balance = getBalance(node);

    if (balance > 1 && key.compareTo(node.left!.key) < 0) {
      return rightRotate(node)!;
    }

    if (balance < -1 && key.compareTo(node.right!.key) > 0) {
      return leftRotate(node)!;
    }

    if (balance > 1 && key.compareTo(node.left!.key) > 0) {
      node.left = leftRotate(node.left!)!;
      return rightRotate(node)!;
    }

    if (balance < -1 && key.compareTo(node.right!.key) < 0) {
      node.right = rightRotate(node.right!)!;
      return leftRotate(node)!;
    }

    return node;
  }

  Offset? search(TreeNode? node, String key) {
    if (node == null) return null;

    if (key == node.key) return node.position;

    if (key.compareTo(node.key) < 0) {
      return search(node.left, key);
    } else {
      return search(node.right, key);
    }
  }

  void insertNode(String key, Offset position) {
    root = insert(root, key, position);
  }

  Offset? getNodePosition(String key) {
    return search(root, key);
  }
}
