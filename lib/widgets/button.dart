import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  Button({
    @required this.label, 
    @required this.onTap,
    this.flex = 1,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.enabled = true
  });

  final String label;
  final GestureTapCallback onTap;
  final int flex;
  final Color textColor;
  final Color backgroundColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: RaisedButton(
        disabledColor: Colors.grey[900],
        disabledTextColor: Colors.grey,
        color: backgroundColor,
        textColor: textColor,
        child: Text(
          label,
          style: TextStyle(fontSize: 24),
        ),
        onPressed: enabled ? onTap : null,
      ),
    );
  }
}