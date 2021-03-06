import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {@required this.id, @required this.title, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id)),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .removeProduct(id);
                      } catch (error) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text('Delete Failed'),
                          ),
                        );
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
