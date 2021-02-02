import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem order;

  const OrderItemCard(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          title: Text('\$${order.amount}'),
          subtitle: Text(DateFormat.yMd().add_jm().format(order.dateTime)),
          trailing: IconButton(
            icon: Icon(Icons.expand_more),
            onPressed: () {},
          )),
    );
  }
}
