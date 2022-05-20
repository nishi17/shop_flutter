import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/productss.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;

  // const ProductDetailScreen(this.title);

  static const rountName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Productss>(context,listen: false).findByid(productId);


    return Scaffold(
        appBar: AppBar(
      title: Text(loadedProduct.title),
    )
    );
  }
}
