import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/cart.dart';
import 'package:flutter_complete_guide/provider/product.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imgUrl;

  // const ProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    var item = Provider.of<Product>(context, listen: false);
    var itemCart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            /*  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => ProductDetailScreen(title)));
          }*/
            Navigator.pushNamed(context, ProductDetailScreen.rountName,
                arguments: item.id);
          },
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  item.isFavourite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                item.toggleFavourite();
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {

              itemCart.addData(item.id,item.price, item.title);
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
