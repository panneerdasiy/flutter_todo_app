
import 'package:flutter/material.dart';

extension CommonWidgets on BuildContext {
  void showSnackBar(text){
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }
}