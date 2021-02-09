import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItemCard extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItemCard(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.all(20),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          Provider.of<Cart>(context, listen: false).removeItemFromCart(id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('x$quantity'),
          ),
        ),
      ),
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Please Confirm'),
                  content: Text('Remove this item from the cart?'),
                  actions: [
                    TextButton(
                      child:
                          Text('No', style: TextStyle(color: Colors.grey[300])),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('YES'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ));
      },
    );
  }
}
