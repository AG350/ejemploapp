import 'package:flutter/material.dart';
import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:ejemplo_app/data/populate_data.dart';
import 'package:ejemplo_app/pages/pages.dart';

class MenuWidget extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      semanticLabel: 'Menu',
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Header(prefs: prefs),
          ListTile(
              leading: Icon(Icons.home, color: Colors.blue),
              title: Text('Home'),
              onTap: () => Navigator.pushNamed(context, HomePage.routeName)),
          ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.blue),
              title: Text('Carro de compras'),
              onTap: () => Navigator.pushReplacementNamed(context, 'cart')),
          ListTile(
              leading: Icon(Icons.add_box_sharp, color: Colors.blue),
              title: Text('Cargar productos para prueba'),
              onTap: () {
                platos.forEach((element) {
                  Dbase().agregaPlato(element);
                });
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              }),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.blue),
            title: Text('Cerrar sesión'),
            onTap: () {
              prefs.logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LandingPage.routeName, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  final PreferenciasUsuario prefs;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Container(
        alignment: Alignment.bottomLeft,
        height: 300,
        width: double.infinity,
        child: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Hola ${prefs.nombreUsuario}',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
