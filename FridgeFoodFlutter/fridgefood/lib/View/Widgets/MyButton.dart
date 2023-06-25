import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  String text;
  Color backgroundColor;
  double buttonwidth;
  VoidCallback onPress;
  Color textColor;
  Color? borderColor;
  // dynamic method;

  MyButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.buttonwidth,
    required this.onPress,
    required this.textColor,
    this.borderColor,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: widget.onPress,
        splashColor: widget.textColor,
        child: Ink(
          height: 50,
          width: widget.buttonwidth,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: widget.borderColor ?? widget.backgroundColor,
                width: 2,
              )),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewButton extends StatefulWidget {
  String text;
  Color backgroundColor;
  double buttonwidth;
  VoidCallback onPress;
  Color textColor;
  Color? borderColor;
  NewButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.buttonwidth,
    required this.onPress,
    required this.textColor,
    this.borderColor,
  });

  @override
  State<NewButton> createState() => _NewButtonState();
}

class _NewButtonState extends State<NewButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      splashColor: widget.textColor,
      child: Container(
        height: 50,
        width: widget.buttonwidth,
        decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: widget.borderColor ?? widget.backgroundColor,
              width: 2,
            )),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
