import 'dart:collection';

import 'package:flutter/cupertino.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<int> schedule = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<int> get items => UnmodifiableListView(schedule);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPrice => schedule.length * 42;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(int item) {
    schedule.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    schedule.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
