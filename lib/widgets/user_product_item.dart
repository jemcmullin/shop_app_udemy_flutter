import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem({@required this.title, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      // TODO
                    }),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () {
                      // TODO
                    }),
              ],
            ),
          )),
    );
  }
}
