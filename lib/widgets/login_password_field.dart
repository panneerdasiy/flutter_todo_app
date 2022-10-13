import 'package:flutter/material.dart';

class LoginPasswordField extends StatefulWidget {
  final TextEditingController _textController;
  final String? error;

  const LoginPasswordField(this._textController, {this.error, super.key});

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  bool obscureText = true;

  void _toggleObscureText() {
    setState(() => obscureText = !obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._textController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: 'Password is password',
          errorText: widget.error,
          icon: const Icon(Icons.lock_outline),
          labelText: 'Password',
          suffixIcon: IconButton(
            onPressed: () => _toggleObscureText(),
            icon: Icon(obscureText
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined),
          )),
    );
  }
}
