import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:ejemplo_app/utils/navigation_util.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Platos de comida';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      initialRoute: 'landing',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => HomePage(),
        'mantenimiento': (_) => MantenimientoPage(),
        'signin': (_) => SignInPage(),
        'signup': (_) => SignUpPage(),
        'landing': (_) => LandingPage(),
        'cart': (_) => CartPage(),
      },
    );
  }
}
