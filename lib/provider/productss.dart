import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_complete_guide/provider/product.dart';

class Productss with ChangeNotifier {
  List<Product> _items

      /*= [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ]*/
      ;

  // var showFavouritesOnly = false;

  List<Product> get item {
    // if(showFavouritesOnly){
    //   return _items.where((element) => element.isFavourite).toList();
    // }

    return [..._items];
  }

  List<Product> get itemFav {
    return _items.where((element) => element.isFavourite).toList();
  }

  // void showOnlyfav(){showFavouritesOnly = true; notifyListeners();}
  // void showAll(){showFavouritesOnly = false;notifyListeners();}

  Product findByid(String id) {
    return item.firstWhere((element) => element.id == id);
  }

  void removeProduct(String productID) {
    _items.removeWhere((element) => element.id == productID);
    notifyListeners();
  }

//method 1
/*  Future<void> addProduct(Product value) {
    final url = Uri.https(
        'flutter-shop-20449-default-rtdb.firebaseio.com', 'products.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': value.title,
        'description': value.description,
        'imageUrl': value.imageUrl,
        'price': value.price.toString(),
        'isFavourite': value.isFavourite.toString(),
      }),
    ) .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
          price: value.price,
          id: json.decode(response.body)['name'],
          imageUrl: value.imageUrl,
          title: value.title,
          description: value.description);

      _items.add(newProduct);
      notifyListeners();
    }).catchError((onError) {
      throw onError;
    });
  }*/

  Future<void> getProduct() async {
    final url = Uri.https(
        'flutter-shop-20449-default-rtdb.firebaseio.com', 'products.json');

    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];

      fetchedData.forEach((prodId, ProdData) {
        // -N3s_qmXkeBrXgkgzzmM: {description: dgdggdhdhd,
        // imageUrl: https://s9.postimg.cc/n92phj9tr/image1.jpg,
        // isFavourite: false, price: 56.0, title: fyty}
        loadedData.add(Product(
          id: prodId,
          isFavourite:bool.fromEnvironment( ProdData['isFavourite'],defaultValue: false),
          description: ProdData['description'],
          title: ProdData['title'],
          imageUrl: ProdData['imageUrl'],
          price: double.parse(ProdData['price']),
        ));

        _items = loadedData;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product value) async {
    final url = Uri.https(
        'flutter-shop-20449-default-rtdb.firebaseio.com', 'products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': value.title,
          'description': value.description,
          'imageUrl': value.imageUrl,
          'price': value.price.toString(),
          'isFavourite': value.isFavourite.toString(),
        }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
          price: value.price,
          id: json.decode(response.body)['name'],
          imageUrl: value.imageUrl,
          title: value.title,
          description: value.description);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product editedProduct) async{
    final productIndex = _items.indexWhere((element) => element.id == id);

    if (productIndex >= 0) {

      final url = Uri.https(
          'flutter-shop-20449-default-rtdb.firebaseio.com', 'products/$id.json');
      
      await http.patch(url,body: json.encode({
        'title': editedProduct.title,
        'description': editedProduct.description,
        'imageUrl': editedProduct.imageUrl,
        'price': editedProduct.price.toString(),
      }));
      _items[productIndex] = editedProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
