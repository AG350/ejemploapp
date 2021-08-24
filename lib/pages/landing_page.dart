import 'package:flutter/material.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/prefs/prefs.dart';

class LandingPage extends StatelessWidget {
  static final String routeName = 'landing';
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    print(prefs.nombreUsuario);
    if (prefs.nombreUsuario == '') {
      return SignInPage();
    }
    return HomePage();
  }
}
