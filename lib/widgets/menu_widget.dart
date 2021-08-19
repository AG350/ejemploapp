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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(),
          ),
          ListTile(
              leading: Icon(Icons.home, color: Colors.blue),
              title: Text('Home'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomePage.routeName)),
          ListTile(
              leading: Icon(Icons.home, color: Colors.blue),
              title: Text('Home3'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, HomePage3.routeName)),
          ListTile(
              leading: Icon(Icons.add_box_sharp, color: Colors.blue),
              title: Text('Populate products'),
              onTap: () {
                platos.forEach((element) {
                  Dbase().agregaPlato(element);
                });
                Navigator.pushReplacementNamed(context, HomePage3.routeName);
              }),
          ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Cart'),
              onTap: () => Navigator.pushReplacementNamed(context, 'cart')),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Log Out'),
            onTap: () {
              prefs.logOut();
              Navigator.pushReplacementNamed(context, LandingPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
