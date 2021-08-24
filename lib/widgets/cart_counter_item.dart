import 'dart:async';

import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class CartCounterItem extends StatefulWidget {
  @override
  _CartCounterItemState createState() => _CartCounterItemState();
}

class _CartCounterItemState extends State<CartCounterItem> {
  int cartLen = DataProvider.count;
  @override
  void initState() {
    DataProvider.carroStream.listen((count) {
      setState(() {
        cartLen = count;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Icon(Icons.shopping_cart),
        if (cartLen > 0)
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              child: Text(
                '$cartLen',
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
