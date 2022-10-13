import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/todo_reference.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:todo_app/screens/dashboard/bloc/dashboard_events.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';

class TodoCheckBox extends StatelessWidget {
  final Todo todo;
  final VoidCallback _onEditPressed;

  const TodoCheckBox(this.todo, this._onEditPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.subtitle1;
    if (todo.completed) {
      style = style!.copyWith(decoration: TextDecoration.lineThrough);
    }
    return Card(
      child: Row(
        children: [
          Checkbox(
              value: todo.completed,
              onChanged: (value) => _onCheckChanged(context, value!)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                todo.title,
                style: style,
                softWrap: true,
              ),
            ),
          ),
          IconButton(
            onPressed: _onEditPressed,
            icon: const Icon(Icons.edit),
          )
        ],
      ),
    );
  }

  void _onCheckChanged(BuildContext context, bool value) {
    BlocProvider.of<DashboardBloc>(context)
        .add(UpdateTodoEvent(todo.copyWith(completed: value)));
  }
}
