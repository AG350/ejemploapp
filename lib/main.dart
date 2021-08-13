import 'package:ejemplo_app/pages/home_page.dart';
import 'package:ejemplo_app/pages/matenimiento_page.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataProvider.obtienePlatosProvider();
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (_) => HomePage(),
        'mantenimiento': (_) => MantenimientoPage()
      },
    );
  }
}
