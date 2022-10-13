import 'package:flutter/material.dart';

typedef ActionsBuilder = List<Widget> Function(BuildContext context);

AppBar myAppBar(BuildContext context, String title,
    {ActionsBuilder? buildActions}) {
  return AppBar(
    title: Center(
        child: Text(title, style: Theme.of(context).textTheme.headline5)),
    actions: buildActions?.call(context),
  );
}
