import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';
import '../widgets/cart_item_card.dart';
import '../providers/cart_provider.dart';
import '../components/projectCircularProgress.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: CartBody(),
    );
  }
}

class CartBody extends StatefulWidget {
  const CartBody({
    Key key,
  }) : super(key: key);

  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var cartValuesList = cart.items.values.toList();
    var _isLoading = false;

    return Stack(
      children: [
        Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text('\$${cart.amountTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await Provider.of<Orders>(context, listen: false)
                              .addOrder(
                            cartValuesList,
                            cart.amountTotal,
                          );
                          cart.clearCart();
                        } catch (error) {
                          throw (error); //Unhandled
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) => CartItemCard(
                    id: cartValuesList[index].id,
                    title: cartValuesList[index].title,
                    quantity: cartValuesList[index].quantity,
                    price: cartValuesList[index].price),
              ),
            )
          ],
        ),
        if (_isLoading) ProjectCircularProgress(),
      ],
    );
  }
}
