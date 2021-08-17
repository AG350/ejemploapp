import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
      stream: DataProvider.userStreamController,
      builder: (context, snapshot) {
        UsuarioModel? user = snapshot.data;
        if (user == null) {
          return SigninPage();
        }
        return HomePage();
      },
    );
  }
}
