import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/product.dart';
import 'package:flutter_complete_guide/provider/productss.dart';
import 'package:provider/provider.dart';

class EditUserProductScreen extends StatefulWidget {
  static const rountName = '/editUserProductscreen';

  @override
  State<EditUserProductScreen> createState() => _EditUserProductState();
}

class _EditUserProductState extends State<EditUserProductScreen> {
  final _priceFocudeNode = FocusNode();
  final _descriptionFocudeNode = FocusNode();
  final _imageUrlFocudeNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _from = GlobalKey<FormState>();
  var _isInit = true;
  var _editedProduct =
      Product(title: '', price: 0, id: null, description: '', imageUrl: '');
  var _initValues = {
    'title': '',
    'desctiption': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocudeNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct = Provider.of<Productss>(context).findByid(productId);
        _initValues = {
          'title': _editedProduct.title,
          'desctiption': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        //  'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text =  _editedProduct.imageUrl;
        }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocudeNode.removeListener(_updateImageUrl);
    _priceFocudeNode.dispose();
    _descriptionFocudeNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocudeNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocudeNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _from.currentState.validate();

    if (!isValid) {
      return;
    }
    _from.currentState.save();

    if(_editedProduct.id!=null){
      Provider.of<Productss>(context, listen: false).updateProduct(_editedProduct.id,_editedProduct);
    }else{
      Provider.of<Productss>(context, listen: false).addProduct(_editedProduct);
    }


    Navigator.of(context).pop();
    /*  print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _from,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocudeNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a input!';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocudeNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocudeNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price!';
                  }

                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid Number!';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Please enter a Number greater than zero!';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocudeNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description!';
                  }

                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }

                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocudeNode,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a Image Url.';
                        }

                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid Url.';
                        }

                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid Image Url.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
