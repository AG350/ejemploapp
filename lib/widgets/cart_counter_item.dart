import 'package:ejemplo_app/models/models.dart';
import 'package:flutter/material.dart';

class CartCounterItem extends StatelessWidget {
  const CartCounterItem(this._carro);

  final List<PlatoModel> _carro;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Icon(Icons.shopping_cart),
        if (_carro.length > 0)
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: Text(
                '${_carro.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
