import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/order_item_card.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Orders')),
        body: Expanded(
            child: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) =>
              OrderItemCard(orderData.orders[index]),
        )));
  }
}
