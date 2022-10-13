
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String string;
  final VoidCallback onPressed;
  final IconData? iconData;

  const MyButton(this.string,
      {required this.onPressed, this.iconData, super.key});

  @override
  Widget build(BuildContext context) {
    return iconData == null ? buildButton() : buildButtonWithIcon();
  }

  ElevatedButton buildButton() {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(string),
    );
  }

  ElevatedButton buildButtonWithIcon() {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(iconData))),
        Expanded(
            flex: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10), child: Text(string)))
      ]),
    );
  }
}

