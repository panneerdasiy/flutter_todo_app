import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/local/todo_dao.dart';
import 'package:todo_app/data/remote/todo_service.dart';
import 'package:todo_app/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:todo_app/screens/dashboard/widgets/dashboard_content.dart';
import 'package:todo_app/use_cases/todo/todo_use_case.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocProvider<DashboardBloc>(
      create: (_) {
        final bloc = DashboardBloc(TodoUseCase(
          TodoDao.instance,
          TodoService(),
        ));
        SharedPreferences.getInstance()
            .then((value) => bloc.sharedPref = value);
        return bloc;
      },
      child: const DashboardContent(),
    ));
  }
}
