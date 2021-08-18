import 'package:ejemplo_app/models/models.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<PlatoModel> _cart;

  CartPage(this._cart);

  @override
  _CartPageState createState() => _CartPageState(this._cart);
}

class _CartPageState extends State<CartPage> {
  _CartPageState(this._cart);

  List<PlatoModel> _cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
          itemCount: _cart.length,
          itemBuilder: (context, index) {
            final item = _cart[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(item.nombre),
                  trailing: GestureDetector(
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          _cart.remove(item);
                        });
                      }),
                ),
              ),
            );
          }),
    );
  }
}
