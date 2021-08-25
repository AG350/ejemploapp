import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo_app/widgets/widgets.dart';
import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/pages/search/search_plato.dart';

// ignore: must_be_immutable
class BottomNavigationCustom extends StatefulWidget {
  @override
  _BottomNavigationCustomState createState() => _BottomNavigationCustomState();
}

class _BottomNavigationCustomState extends State<BottomNavigationCustom> {
  final List<PlatoModel> historial = [];

  static int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      onTap: (index) async {
        ///TODO tener cuidado con los   Navigator.pushNamed() que al precionar en una opcion vas acumulando ventanas abiertas
        switch (index) {
          case 0:

            ///Podes poner la condicion de que si la pagina actual es la misma a la que queres navegar no realice la accion
            if (ModalRoute.of(context)?.settings.name != 'home')
              Navigator.pushReplacementNamed(context, 'home');
            break;
          case 1:
            if (DataProvider.carritoTemporal.length > 0) {
              Navigator.pushReplacementNamed(context, 'cart');
            }
            break;
          case 2:
            if (ModalRoute.of(context)?.settings.name != 'cart') {
              final plato = await showSearch(
                context: context,
                delegate: SearchPlato('Buscar plato..', historial),
              );
              setState(
                () {
                  if (plato != null) {
                    historial.insert(0, plato);
                  }
                },
              );
            }
            break;
          default:
        }
        setState(() {
          _selectedIndex = index;
        });
      }, // new
      currentIndex: _selectedIndex, // new
      items: ModalRoute.of(context)?.settings.name != 'cart'
          ? [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: CartCounterItem(),
                label: 'Carro',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Buscar',
              )
            ]
          : [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: CartCounterItem(),
                label: 'Carro',
              )
            ],
    );
  }
}
