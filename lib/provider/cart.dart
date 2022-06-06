import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int qunatity;

  CartItem({this.id, this.title, this.price, this.qunatity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, value) {
      total += value.price * value.qunatity;
    });

    return total;
  }

  void addData(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
              (value) =>
              CartItem(
                  id: value.id,
                  price: value.price,
                  qunatity: value.qunatity + 1,
                  title: value.title));
    } else {
      _items.putIfAbsent(
          productId,
              () =>
              CartItem(
                  id: DateTime.now().toString(),
                  price: price,
                  qunatity: 1,
                  title: title));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }

    if (_items[id].qunatity > 1) {
      _items.update(id, (value) =>
          CartItem(id: value.id,
              title: value.title,
              price: value.price,
              qunatity: value.qunatity - 1));
    }else{
      _items.remove(id);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
