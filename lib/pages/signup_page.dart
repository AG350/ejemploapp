import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final db = new Dbase();
  final _emailController = new TextEditingController();
  final _passController = new TextEditingController();
  final _nameController = new TextEditingController();
  @override
  void initState() {
    _emailController.text = '';
    _passController.text = '';
    _nameController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Nombre del usuario',
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                        controller: _nameController,
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
                            'Registrarse',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final user = new UsuarioModel(
                              email: _emailController.text,
                              nombre: _nameController.text,
                              password: _passController.text,
                            );
                            print(db.guardarUsuario(user));
                            SnackBar snackBar =
                                SnackBar(content: Text('Cuenta creada.'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pushNamed(context, 'signin');
                          } catch (e) {
                            print('Error en crear: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              MaterialButton(
                onPressed: () => Navigator.pushNamed(context, 'signin'),
                child: Text('Ingresar', style: TextStyle(color: Colors.blue)),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.blue, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
