import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:ejemplo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static final String routeName = 'signin';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: LoginForm(),
              ),
              SizedBox(height: 50),
              BottomButton('Registrarse', SignUpPage.routeName),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final signInFormGlobalKey = GlobalKey<FormState>();
  final prefs = new PreferenciasUsuario();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signInFormGlobalKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          CustomFormField(
            label: 'Correo',
            validator: emailValidator,
            controller: _emailController,
            iconData: Icons.alternate_email_rounded,
            type: TextInputType.emailAddress,
          ),
          SizedBox(height: 30),
          CustomFormField(
            label: 'Contraseña',
            validator: stringLongValidator,
            controller: _passController,
            iconData: Icons.lock_outline,
            isTextObscured: true,
          ),
          SizedBox(height: 30),
          SignInButton(
            signInFormGlobalKey,
            _emailController,
            _passController,
          )
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  SignInButton(
    this.formGlobalKey,
    this.emailController,
    this.passController,
  );

  final GlobalKey<FormState> formGlobalKey;
  final TextEditingController emailController;
  final TextEditingController passController;
  final prefs = new PreferenciasUsuario();
  final db = new Dbase();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.blue,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text('Ingresar', style: TextStyle(color: Colors.white)),
      ),
      onPressed: () async {
        if (formGlobalKey.currentState?.validate() == true) {
          final user = await db.obtenerUsuario(
              emailController.text, passController.text);
          try {
            if (user.email == emailController.text && user.email != '') {
              prefs.nombreUsuario = user.nombre;
              Navigator.pushNamed(context, 'home');
            } else {
              SnackBar snackBar = SnackBar(
                  content: Text(
                      'No existe el usuario y/o contraseña, revisar o crear cuenta'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              throw FormatException('revisar cuenta');
            }
          } catch (e) {
            print('Error en ingreso: $e');
          }
        }
      },
    );
  }
}
