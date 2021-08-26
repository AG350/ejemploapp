import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/utils/snack_bar_util.dart';
import 'package:ejemplo_app/widgets/menu_widget.dart';
import 'package:ejemplo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'pages.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      drawer: MenuWidget(),
      body: BodyCart(),
      bottomNavigationBar: BottomNavigationCustom(),
    );
  }
}

//DONE Podrias hacer un stream del carrito temporal para evitar usar un StatefulWidget y en su lugar utilizas un streamBuilder para redibujar la vista

class BodyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DataProvider.carroStream,
        initialData: DataProvider.carritoTemporal,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final carro = snapshot.data;
          return Container(
            child: ListView.builder(
              itemCount: carro.length,
              itemBuilder: (context, index) {
                final item = carro[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(item.nombre),
                      trailing: Icon(Icons.remove_circle, color: Colors.red),
                      onTap: () {
                        DataProvider.quitarItemCarrito(item);
                        DataProvider.obtienePlatosCarroProvider();
                        if (index <= 0) {
                          Utils.showSnackBar(context, 'Carrito vacio');
                          Navigator.pushReplacementNamed(
                              context, HomePage.routeName);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
