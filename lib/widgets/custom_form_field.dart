import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final IconData iconData;
  final bool? isTextObscured;
  final bool? autoCorrect;
  final TextInputType? type;

  const CustomFormField({
    Key? key,
    required this.label,
    this.validator,
    required this.controller,
    required this.iconData,
    this.isTextObscured,
    this.autoCorrect, 
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      autocorrect: autoCorrect ?? false,
      obscureText: isTextObscured ?? false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(iconData),
      ),
      validator: validator,
      controller: controller,
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

String? stringLongValidator(String? fieldContent) => fieldContent!.length >= 6
    ? null
    : 'El campo es obligatorio y longitud mayor a 6';
