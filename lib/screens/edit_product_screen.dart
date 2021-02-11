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

  @override
  void initState() {
    super.initState();
    _urlEntryFocus.addListener(_urlEntryListener);
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

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(
      Product(
          id: null,
          title: _productHandler['title'],
          description: _productHandler['description'],
          price: double.parse(_productHandler['price']),
          imageUrl: _productHandler['imageUrl']),
    );
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_priceFocus),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please include a title and resave';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _productHandler['title'] = newValue,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    focusNode: _priceFocus,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_descriptionFocus);
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
                    onSaved: (newValue) => _productHandler['price'] = newValue,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
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
                          decoration: InputDecoration(labelText: 'Image URL'),
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
