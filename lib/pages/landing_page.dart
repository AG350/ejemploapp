import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final pref = Pref();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
      stream: DataProvider.userStreamController,
      builder: (context, snapshot) {
        print(pref.usuario);
        UsuarioModel? user = snapshot.data;
        if (pref.usuario != '') {
          return SigninPage();
        }
        return HomePage();
      },
    );
  }
}
