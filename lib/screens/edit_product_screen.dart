import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlEntryFocus = FocusNode();
  final _imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _productHandler = <String, String>{};
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
  };
  var isInit = true;
  var _isLoading = false;
  Product _editingProduct;

  @override
  void initState() {
    super.initState();
    _urlEntryFocus.addListener(_urlEntryListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final _editingId =
          ModalRoute.of(context).settings.arguments as String; //id of product
      if (_editingId != null) {
        _editingProduct =
            Provider.of<Products>(context, listen: false).findById(_editingId);
        _initValues = {
          'title': _editingProduct.title,
          'price': _editingProduct.price.toString(),
          'description': _editingProduct.description,
        };
        _imageController.text = _editingProduct.imageUrl;
      }
    }
    isInit = false;
  }

  @override
  void dispose() {
    _urlEntryFocus.removeListener(_urlEntryListener);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageController.dispose();
    _urlEntryFocus.dispose();
    super.dispose();
  }

  void _urlEntryListener() {
    if (!_urlEntryFocus.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editingProduct == null) {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(
          Product(
              id: null,
              title: _productHandler['title'],
              description: _productHandler['description'],
              price: double.parse(_productHandler['price']),
              imageUrl: _productHandler['imageUrl']),
        );
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An Error Occured'),
            content: Text('Something went wrong!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
      // } finally {
      //   setState(() => _isLoading = false);
      //   Navigator.of(context).pop();
      // }
    } else {
      await Provider.of<Products>(context, listen: false).updateProduct(
        _editingProduct.id,
        Product(
          id: _editingProduct.id,
          title: _productHandler['title'],
          description: _productHandler['description'],
          price: double.parse(_productHandler['price']),
          imageUrl: _productHandler['imageUrl'],
          isFavorite: _editingProduct.isFavorite,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveForm(),
            ),
          ],
        ),
        body: _isLoading
            ? CircularProgressIndicator.adaptive()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Title'),
                          initialValue: _initValues['title'],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) =>
                              FocusScope.of(context).requestFocus(_priceFocus),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please include a title and resave';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _productHandler['title'] = newValue,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Price'),
                          initialValue: _initValues['price'],
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          focusNode: _priceFocus,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocus);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please include a price and resave';
                            } else if (double.tryParse(value) == null) {
                              return 'Please enter a valid number and resave';
                            } else if (double.parse(value) < 0) {
                              return 'Please enter a positive value and resave';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _productHandler['price'] = newValue,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          initialValue: _initValues['description'],
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocus,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please include a description and resave';
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              _productHandler['description'] = newValue,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8, right: 8),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: _imageController.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageController,
                                focusNode: _urlEntryFocus,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please include a URL and resave';
                                  }
                                  var urlPattern =
                                      r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|jpeg|gif|png)";
                                  if (RegExp(urlPattern, caseSensitive: false)
                                          .firstMatch(value) ==
                                      null) {
                                    return 'Please enter a valid image URL';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) =>
                                    _productHandler['imageUrl'] = newValue,
                                onFieldSubmitted: (_) => _saveForm(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
