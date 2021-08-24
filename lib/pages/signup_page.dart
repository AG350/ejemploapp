import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/utils/snack_bar_util.dart';
import 'package:ejemplo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static final String routeName = 'signup';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                child: SignUpForm(
                  _emailController,
                  _nameController,
                  _passController,
                ),
              ),
              SizedBox(height: 50),
              BottomButton('Ingresar', SignInPage.routeName),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final signUpFormGlobalKey = GlobalKey<FormState>();
  SignUpForm(
    this.emailController,
    this.nameController,
    this.passController,
  );

  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: signUpFormGlobalKey,
      child: Column(
        children: [
          CustomFormField(
            label: 'Correo electronico',
            validator: emailValidator,
            controller: emailController,
            iconData: Icons.alternate_email_rounded,
          ),
          SizedBox(height: 30),
          CustomFormField(
            label: 'Nombre',
            validator: stringLongValidator,
            controller: nameController,
            iconData: Icons.person_outline_sharp,
          ),
          SizedBox(height: 30),
          CustomFormField(
            label: 'Contraseña',
            validator: stringLongValidator,
            controller: passController,
            iconData: Icons.lock_outline,
            isTextObscured: true,
          ),
          SizedBox(height: 30),
          SignUpButton(
            signUpFormGlobalKey,
            emailController,
            nameController,
            passController,
          ),
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  SignUpButton(
    this.signUpFormGlobalKey,
    this.emailController,
    this.nameController,
    this.passController,
  );

  final GlobalKey<FormState> signUpFormGlobalKey;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passController;
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
        child: Text(
          'Registrarse',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () {
        if (signUpFormGlobalKey.currentState?.validate() == true) {
          try {
            final user = new UsuarioModel(
              email: emailController.text,
              nombre: nameController.text,
              password: passController.text,
            );
            db.guardarUsuario(user).then(
              (value) {
                if (!value) {
                  Utils.showSnackBar(context, 'Usuario ya registrado');
                  return;
                }
                Utils.showSnackBar(context, 'Cuenta creada');
                Navigator.pushNamed(context, 'signin');
              },
            );
          } catch (e) {
            print('Error en crear: $e');
          }
        }
      },
    );
  }
}
