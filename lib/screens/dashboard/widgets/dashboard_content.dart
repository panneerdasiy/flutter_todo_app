import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/todo_reference.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:todo_app/screens/dashboard/bloc/dashboard_events.dart';
import 'package:todo_app/screens/dashboard/bloc/dashboard_state.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';
import 'package:todo_app/screens/dashboard/widgets/todo_check_box.dart';
import 'package:todo_app/screens/details/bloc/details_screen_result.dart';
import 'package:todo_app/screens/todo_actions.dart';
import 'package:todo_app/widgets/common_widgets.dart';
import 'package:todo_app/widgets/my_app_bar.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state){
        if (state.logOut){
          SystemNavigator.pop();
          context.showSnackBar('Logged out!');
        }
      },
      child: Scaffold(
          appBar: myAppBar(
            context,
            'Todo List',
            buildActions: _buildAppbarActions,
          ),
          drawer: _buildDrawer(context),
          body:
              BlocBuilder<DashboardBloc, DashboardState>(builder: _buildContent)),
    );
  }

  List<PopupMenuEntry<int>> _popMenuItemBuilder(BuildContext context) {
    return [
      const PopupMenuItem(value: 0, child: Text('Add')),
      const PopupMenuItem(value: 1, child: Text('Sub')),
      const PopupMenuItem(value: 2, child: Text('Log out')),
    ];
  }

  void _onPopupMenuSelected(BuildContext context, int value) {
    switch (value) {
      case 0:
        Navigator.pushNamed(context, Routes.details).then((value) {
          if (value != null) {
            handleDetailsScreenResult(context, value as DetailsScreenResult);
          }
        });
        break;
      case 1:
        context.showSnackBar('minus pressed!');
        break;
      case 2:
        _onLogoutPressed(context);
        break;
      default:
        context.showSnackBar('Unknown option!');
    }
  }

  void handleDetailsScreenResult(
      BuildContext context, DetailsScreenResult result) {
    Todo todo = result.todo;
    switch (result.actions) {
      case TodoActions.update:
        context.read<DashboardBloc>().add(UpdateResultEvent(todo.id));
        break;
      case TodoActions.delete:
        context.read<DashboardBloc>().add(DeleteResultEvent(todo));
        break;
      case TodoActions.save:
        context.read<DashboardBloc>().add(SaveResultEvent(todo));
        break;
      default:
        throw 'unknown todo action';
    }
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Text('Todo App'),
          ),
          ListTile(
            title: const Text('Add'),
            onTap: () {
              Navigator.popAndPushNamed(context, Routes.details).then((value) {
                if (value != null) {
                  handleDetailsScreenResult(
                      context, value as DetailsScreenResult);
                }
              });
            },
          ),
          ListTile(
            title: const Text('Sub'),
            onTap: () {
              Navigator.pop(context);
              context.showSnackBar('Sub pressed!');
            },
          ),
          ListTile(
            title: const Text('Div'),
            onTap: () {
              Navigator.pop(context);
              context.showSnackBar('Div pressed!');
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppbarActions(BuildContext context) {
    return [
      PopupMenuButton(
        itemBuilder: _popMenuItemBuilder,
        onSelected: (value) => _onPopupMenuSelected(context, value),
      )
    ];
  }

  Widget _buildContent(BuildContext context, DashboardState state) {
    if (state.todosApiError.isNotEmpty) {
      return AlertDialog(
        title: const Text('Something went wrong'),
        content: const Text('Give it another try'),
        actions: [
          TextButton(
              onPressed: () => _reloadTodosApi(context),
              child: const Text('RELOAD'))
        ],
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Todo>? todos = state.todos;
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8)
            .copyWith(bottom: index < todos.length - 1 ? 0 : 8),
        child: TodoCheckBox(
          todos[index],
          () => _onEditPressed(
            context,
            todos[index],
          ),
        ),
      ),
    );
  }

  void _onEditPressed(BuildContext context, Todo todo) {
    Navigator.of(context).pushNamed(
      Routes.details,
      arguments: {
        TodoReference.id: todo.id,
      },
    ).then((value) {
      if (value != null) {
        handleDetailsScreenResult(context, value as DetailsScreenResult);
      }
    });
  }

  void _reloadTodosApi(BuildContext context) {
    BlocProvider.of<DashboardBloc>(context).add(GetTodosEvent());
  }

  void _onLogoutPressed(BuildContext context) {
    BlocProvider.of<DashboardBloc>(context).add(LogoutEvent());
  }
}
