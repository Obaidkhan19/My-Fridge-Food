import 'package:flutter/material.dart';
import 'package:fridgefood/constants.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObsecure;
  final IconData icon;
  final bool enable;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isObsecure = false,
    required this.icon,
    this.enable = true,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late FocusNode focusNode = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enable,
      focusNode: focusNode,
      cursorColor: Colors.black,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          bottom: 25,
        ),
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
        floatingLabelStyle: TextStyle(color: themeColor),
        prefixIcon: Icon(
          widget.icon,
          color: focusNode.hasFocus ? themeColor : Colors.black,
        ),
        fillColor: themeColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: themeColor,
          ),
        ),
      ),
      obscureText: widget.isObsecure,
    );
  }
}

class PassTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enable;
  const PassTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.enable = true,
  });

  @override
  State<PassTextField> createState() => _PassTextFieldState();
}

class _PassTextFieldState extends State<PassTextField> {
  bool isObsecure = true;
  late FocusNode focusNode = FocusNode()
    ..addListener(() {
      setState(() {});
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enable,
      focusNode: focusNode,
      cursorColor: Colors.black,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          bottom: 25,
        ),
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.black),
        floatingLabelStyle: TextStyle(color: themeColor),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: focusNode.hasFocus ? themeColor : Colors.black,
        ),
        suffixIcon: InkWell(
          onTap: (() {
            setState(() {
              isObsecure = !isObsecure;
            });
          }),
          child: Icon(
            isObsecure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: focusNode.hasFocus ? themeColor : Colors.black,
          ),
        ),
        fillColor: themeColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: themeColor,
          ),
        ),
      ),
      obscureText: isObsecure,
    );
  }
}
