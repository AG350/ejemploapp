import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final prefs = new PreferenciasUsuario();
  final db = new Dbase();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  @override
  void initState() {
    _emailController.text = '';
    _passController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      LoginField(
                        label: 'Correo',
                        // declare the validator here...
                        // valiator: (fieldContent) => fieldContent.isEmpty? 'Ce champ est obligatoire.': null
                        // or use your custom validator function
                        validator: emailValidator,
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        autocorrect: false,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: '*****',
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        controller: _passController,
                        validator: (value) {
                          return (value != null && value.length >= 6)
                              ? null
                              : 'La contraseña debe de ser de 6 caracteres';
                        },
                      ),
                      SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledColor: Colors.grey,
                        elevation: 0,
                        color: Colors.deepPurple,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: Text(
                            'Ingresar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          final user = await db.obtenerUsuario(
                              _emailController.text, _passController.text);
                          try {
                            if (user.email == _emailController.text &&
                                user.email != '') {
                              prefs.nombreUsuario = user.nombre;
                              Navigator.pushNamed(context, 'home');
                            } else {
                              SnackBar snackBar = SnackBar(
                                  content: Text(
                                      'No existe el usuario y/o contraseña, revisar o crear cuenta'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              throw FormatException('revisar cuenta');
                            }
                          } catch (e) {
                            print('Error en ingreso: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              MaterialButton(
                onPressed: () => Navigator.pushNamed(context, 'signup'),
                child:
                    Text('Crear cuenta', style: TextStyle(color: Colors.blue)),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.blue, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? emailValidator(String? fieldContent) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);

  return regExp.hasMatch(fieldContent ?? '')
      ? null
      : 'El valor ingresado no luce como un correo';
}

String? stringLongValidator(String? fieldContent) =>
    fieldContent!.isEmpty && fieldContent.length > 6
        ? 'El campo es obligatorio y longitud mayor a 6'
        : null;

class LoginField extends StatelessWidget {
  final String? changedValue;
  final String? label;
  final bool? isTextObscured;
  final String? Function(String?)? validator;

  const LoginField({
    Key? key,
    this.changedValue,
    this.label,
    this.isTextObscured,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
