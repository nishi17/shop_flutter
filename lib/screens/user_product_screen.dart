import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/productss.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'edit_user_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const rountName = '/userProductScreen';

  Future<void> _refreshProduct(BuildContext context) async{
    await Provider.of<Productss>(context,listen: false).getProduct();
  }

  @override
  Widget build(BuildContext context) {


    final productData = Provider.of<Productss>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).pushNamed(EditUserProductScreen.rountName);
          }, icon: const Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh:() => _refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(
              children: [
                UserProductItem(  productData.item[i].id,
                    productData.item[i].title, productData.item[i].imageUrl),
                Divider(),
              ],
            ),
            itemCount: productData.item.length,
          ),
        ),
      ),
    );
  }
}
