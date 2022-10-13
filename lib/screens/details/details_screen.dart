import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/local/todo_dao.dart';
import 'package:todo_app/data/remote/todo_service.dart';
import 'package:todo_app/data/todo_reference.dart';
import 'package:todo_app/screens/details/bloc/details_bloc.dart';
import 'package:todo_app/screens/details/bloc/details_event.dart';
import 'package:todo_app/screens/details/bloc/details_screen_result.dart';
import 'package:todo_app/screens/details/bloc/details_state.dart';
import 'package:todo_app/use_cases/todo/todo_use_case.dart';
import 'package:todo_app/widgets/common_widgets.dart';
import 'package:todo_app/widgets/my_app_bar.dart';
import 'package:todo_app/widgets/my_button.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    bool isSaveMode = arguments == null;
    final Map<String, dynamic>? map =
        isSaveMode ? null : arguments as Map<String, dynamic>;

    final bloc = DetailsBloc(
      TodoUseCase(TodoDao.instance, TodoService()),
      isSaveMode,
      map?[TodoReference.id],
    );

    final textController = TextEditingController();

    return BlocListener<DetailsBloc, DetailsState>(
      bloc: bloc,
      listener: (context, state) => _detailsBlocListener(
        context,
        state,
        textController,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar(context, 'Details'),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<DetailsBloc, DetailsState>(
              bloc: bloc,
              builder: (context, state) {
                return (state.isLoading)
                    ? const Center(child: CircularProgressIndicator())
                    : buildDetailsContent(
                        isSaveMode, textController, context, bloc);
              },
            ),
          ),
        ),
      ),
    );
  }

  Column buildDetailsContent(
    bool isSaveMode,
    TextEditingController textController,
    BuildContext context,
    DetailsBloc bloc,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.multiline,
            controller: textController,
            maxLines: 99999,
            autofocus: true,
            style: Theme.of(context).textTheme.headline5?.copyWith(height: 1.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: (isSaveMode)
              ? SizedBox(
                  width: double.infinity,
                  child: MyButton(
                    'Save',
                    onPressed: () => bloc.add(SaveEvent(textController.text)),
                  ),
                )
              : buildEditModeButtons(bloc, textController),
        ),
      ],
    );
  }

  void onItemDoesNotExistError(BuildContext context) {
    context.showSnackBar('Todo Item does not exist!');
    Navigator.of(context).pop();
  }

  void _detailsBlocListener(
    BuildContext context,
    DetailsState state,
    TextEditingController textController,
  ) {
    log('details executed result = $state');
    if (state.todo == null) {
      onItemDoesNotExistError(context);
      return;
    }

    textController.text = state.todo?.title ?? "";

    if (state.actionDone != null) {
      Navigator.of(context)
          .pop(DetailsScreenResult(state.actionDone!, state.todo!));
      return;
    }
  }

  Widget buildEditModeButtons(
      DetailsBloc bloc, TextEditingController textController) {
    return Row(
      children: [
        Expanded(
          child: MyButton(
            'Update',
            onPressed: () => bloc.add(UpdateEvent(textController.text)),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: MyButton(
            'Delete',
            onPressed: () => bloc.add(DeleteEvent()),
          ),
        ),
      ],
    );
  }
}
