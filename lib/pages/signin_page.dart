import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  final _scaffkey = GlobalKey<ScaffoldState>();
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
                  child: Column(
                    children: [
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'john.doe@gmail.com',
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                        controller: _emailController,
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
                              Navigator.pushNamed(context, 'home3');
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
