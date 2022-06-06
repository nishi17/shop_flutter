import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/provider/cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItems(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  void addOrders(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItems(
            id: DateTime.now().toString(),
            products: cartProducts,
            amount: total,
            datetime: DateTime.now()));
    notifyListeners();
  }
}
