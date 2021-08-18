import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/utils/navigation_util.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      navigatorKey: NavigationService.instance.navigationKey,
      initialRoute: 'landing',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => HomePage(),
        'mantenimiento': (_) => MantenimientoPage(),
        'signin': (_) => SigninPage(),
        'signup': (_) => SignupPage(),
        'landing': (_) => LandingPage(),
        'cart': (_) => CartPage(),
      },
    );
  }
}
