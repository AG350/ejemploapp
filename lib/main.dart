import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/utils/navigation_util.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Aplicacion de platos de comida';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      navigatorKey: NavigationService.instance.navigationKey,
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => HomePage(),
        'home2': (_) => HomePage2(),
        'mantenimiento': (_) => MantenimientoPage(),
        'signin': (_) => SigninPage(),
        'signup': (_) => SignupPage(),
        'landing': (_) => LandingPage(),
        'cart': (_) => CartPage(),
      },
    );
  }
}
