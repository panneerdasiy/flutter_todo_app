
import 'package:flutter/material.dart';

class LoginEmailField extends StatelessWidget {
  final TextEditingController _textController;
  final String? error;

  const LoginEmailField(
      this._textController, {
        this.error,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          errorText: error,
          hintText: 'Use any valid email id',
          icon: const Icon(Icons.account_circle_outlined),
          labelText: 'Email ID'),
    );
  }
}
