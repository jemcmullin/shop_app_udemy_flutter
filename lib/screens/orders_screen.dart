import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item_card.dart';
import '../providers/orders_provider.dart';
import '../components/projectCircularProgress.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Orders')),
        drawer: AppDrawer(),
        body: _isLoading
            ? ProjectCircularProgress(
                customColor: Colors.white,
              )
            : Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, index) =>
                          OrderItemCard(orderData.orders[index]),
                    ),
                  )),
                ],
              ));
  }
}
