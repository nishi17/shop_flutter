import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/orders.dart';
import 'package:flutter_complete_guide/widgets/cart_item.dart' as ci;
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static const rountName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrders(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => ci.CartItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].price,
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].qunatity),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }
}
