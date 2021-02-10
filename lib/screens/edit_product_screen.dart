import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _urlEntryFocus.addListener(_urlEntryListener);
  }

  @override
  void dispose() {
    super.dispose();
    _urlEntryFocus.removeListener(_urlEntryListener);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageController.dispose();
    _urlEntryFocus.dispose();
  }

  void _urlEntryListener() {
    if (!_urlEntryFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit Product')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_priceFocus),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocus,
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(_descriptionFocus),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocus,
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
                          decoration: InputDecoration(labelText: 'Enter URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageController,
                          focusNode: _urlEntryFocus,
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
