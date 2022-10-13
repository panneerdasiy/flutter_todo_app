import 'package:flutter/material.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/screens/dashboard/dashboard_screen.dart';
import 'package:todo_app/screens/details/details_screen.dart';
import 'package:todo_app/screens/login/login_screen.dart';
import 'package:todo_app/widgets/my_material_app.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyMaterialApp(routes: {
      Routes.start: (_) => LoginScreen(),
      Routes.dashboard: (_) => const DashboardScreen(),
      Routes.details: (_) => const DetailsScreen()
    });
  }
}
