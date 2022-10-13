import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:todo_app/data/todo_use_case.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';
import 'package:todo_app/screens/details/bloc/details_event.dart';
import 'package:todo_app/screens/details/bloc/details_state.dart';
import 'package:todo_app/screens/todo_actions.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final TodoUseCase _useCase;
  final bool isSaveMode;

  DetailsBloc(
    this._useCase,
    this.isSaveMode,
    int? todoId,
  ) : super(const DetailsState(isLoading: true)) {
    if (isSaveMode) {
      emit(const DetailsState(isLoading: false));
    } else {
      _onInitEditModeEvent(todoId!);
    }

    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<SaveEvent>(_onSaveEvent);
  }

  void _onUpdateEvent(UpdateEvent event, Emitter<DetailsState> emit) async {
    log('update event = ${event.title}');
    Todo updatedTodo = state.todo!.copyWith(title: event.title);
    log('update event = ${await _useCase.updateTodo(updatedTodo)}');
    emit(state.copyWith(actionDone: TodoActions.update, todo: updatedTodo));
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<DetailsState> emit) async {
    log('delete event = ${await _useCase.deleteTodo(state.todo!)}');
    emit(state.copyWith(actionDone: TodoActions.delete));
  }

  void _onInitEditModeEvent(int todoId) {
    _useCase.getTodo(todoId).then(
          (value) => emit(
            state.copyWith(
              isLoading: false,
              todo: value,
            ),
          ),
        );
  }

  void _onSaveEvent(SaveEvent event, Emitter<DetailsState> emit) async {
    List<Todo> todos = await _useCase.getLocalTodos();
    todos.sort((a, b) => a.id.compareTo(b.id));

    int id = todos.isEmpty ? 1 : todos.last.id + 1;
    final newTodo = Todo(id: id, title: event.title, completed: false);

    log('save id = $id');
    log('save event = ${await _useCase.saveTodo(newTodo)}');
    emit(state.copyWith(todo: newTodo, actionDone: TodoActions.save));
  }
}
