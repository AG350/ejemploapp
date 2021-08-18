import 'package:flutter/material.dart';
import 'package:ejemplo_app/pages/pages.dart';

class MenuWidget extends StatelessWidget {
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
              leading: Icon(Icons.people_alt_sharp, color: Colors.blue),
              title: Text('Users'),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.add_box_sharp, color: Colors.blue),
              title: Text('Products'),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Cart'),
              onTap: () => Navigator.pushReplacementNamed(context, 'cart')),
        ],
      ),
    );
  }
}
