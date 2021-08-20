import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<PlatoModel> _carro = DataProvider.carritoTemporal;
  @override
  void initState() {
    print(_carro.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      drawer: MenuWidget(),
      body: ListView.builder(
        itemCount: _carro.length,
        itemBuilder: (context, index) {
          final item = _carro[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                title: Text(item.nombre),
                subtitle: null,
                trailing: GestureDetector(
                  child: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(
                      () {
                        _carro.remove(item);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'home3'),
        child: Icon(Icons.home),
      ),
    );
  }
}
