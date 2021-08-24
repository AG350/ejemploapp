import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
    this.label,
    this.route,
  );

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
          route, (Route<dynamic> route) => false),
      child: Text(label, style: TextStyle(color: Colors.blue)),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        side:
            BorderSide(color: Colors.blue, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
