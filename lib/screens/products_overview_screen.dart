import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/cart.dart';
import 'package:flutter_complete_guide/provider/product.dart';
import 'package:flutter_complete_guide/provider/productss.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var isShowFavOnly = false;

  @override
  Widget build(BuildContext context) {
    //  final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (selectedvalue) {
                setState(() {
                  if (selectedvalue == FilterOptions.Favourites) {
                    // _productContanier.showOnlyfav();
                    isShowFavOnly = true;
                  } else {
                    // _productContanier.showAll();
                    isShowFavOnly = false;
                  }
                  print(selectedvalue);
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.rountName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(isShowFavOnly),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  var isShowFavOnly;

  ProductsGrid(this.isShowFavOnly);

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<Productss>(context);
    var products =
        isShowFavOnly ? productProvider.itemFav : productProvider.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10.5),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            /*  products[i].id, products[i].title, products[i].imageUrl*/),
      ),
    );
  }
}
