import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataProvider.obtienePlatosProvider();
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'landing',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => HomePage(),
        'mantenimiento': (_) => MantenimientoPage(),
        'signin': (_) => SigninPage(),
        'signup': (_) => SignupPage(),
        'landing': (_) => LandingPage(),
      },
    );
  }
}
