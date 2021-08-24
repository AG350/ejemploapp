import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/widgets/menu_widget.dart';
import 'package:ejemplo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  static final String routeName = 'cart';
  final List<PlatoModel> _carro = DataProvider.carritoTemporal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      drawer: MenuWidget(),
      body: CartBody(),
      bottomNavigationBar: BottomNavigationCustom(
        carro: _carro,
      ),
    );
  }
}

class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  final List<PlatoModel> carro = DataProvider.carritoTemporal;

  @override
  Widget build(BuildContext context) {
    DataProvider.obtienePlatosCarro();
    return ListView.builder(
      itemCount: carro.length,
      itemBuilder: (context, index) {
        final item = carro[index];
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
                  setState(() {
                    carro.remove(item);
                    DataProvider.cartStreamController.add(carro.length);
                    DataProvider.obtienePlatosCarro();
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
