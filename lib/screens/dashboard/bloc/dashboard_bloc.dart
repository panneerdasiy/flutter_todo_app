import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/remote/api_exception.dart';
import 'package:todo_app/data/shared_pref_keys.dart';
import 'package:todo_app/screens/dashboard/bloc/todo.dart';
import 'package:todo_app/use_cases/todo/abstract_todo_use_case.dart';

import 'dashboard_events.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AbstractTodoUseCase _useCase;
  late SharedPreferences _sharedPref;

  set sharedPref(value) {
    _sharedPref = value;
    _onGetTodosEvent();
  }

  DashboardBloc(this._useCase)
      : super(const DashboardState(
            isLoading: true, todosApiError: "", todos: [])) {
    on<GetTodosEvent>((_, __) => _onGetTodosEvent());
    on<LogoutEvent>((_, emit) => _onLogoutEvent(emit));
    on<OpenTodoEvent>(_onOpenTodoEvent);
    on<UpdateTodoEvent>(_onUpdateTodoEvent);
    on<UpdateResultEvent>(_onUpdateResultEvent);
    on<DeleteResultEvent>(_onDeleteResultEvent);
    on<SaveResultEvent>(_onSaveResultEvent);
  }

  void _onGetTodosEvent() async {
    try {
      emit(const DashboardState(isLoading: true, todosApiError: "", todos: []));

      List<Todo> todos = await _useCase.getTodos();
      log('response = $todos');

      emit(state.copyWith(
        isLoading: false,
        todos: todos,
        todosApiError: "",
      ));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
            isLoading: false,
            todos: [],
            todosApiError: 'response code = ${e.message}'),
      );
    }
  }

  void _onOpenTodoEvent(OpenTodoEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(todoToOpen: event.todo));
  }

  void _onUpdateTodoEvent(
    UpdateTodoEvent event,
    Emitter<DashboardState> emit,
  ) async {
    log("check : ${event.todo.id}");
    log("check update return: ${await _useCase.updateTodo(event.todo)}");

    emitUpdatedList(event.todo, emit);
  }

  void _onUpdateResultEvent(
    UpdateResultEvent event,
    Emitter<DashboardState> emit,
  ) async {
    Todo? todo = await _useCase.getTodo(event.todoId);
    emitUpdatedList(todo!, emit);
  }

  void emitUpdatedList(
    Todo todo,
    Emitter<DashboardState> emit,
  ) {
    final List<Todo> todos = getUpdatedList(todo);
    emit(state.copyWith(todos: todos));
  }

  List<Todo> getUpdatedList(
    Todo todo,
  ) {
    return state.todos.map((e) => (e.id == todo.id) ? todo : e).toList();
  }

  void _onDeleteResultEvent(
    DeleteResultEvent event,
    Emitter<DashboardState> emit,
  ) {
    log('on delete result event ${event.todo}');
    state.todos.removeWhere((e) => e.id == event.todo.id);
    emit(state.copyWith(todos: state.todos.toList()));
  }

  void _onSaveResultEvent(SaveResultEvent event, Emitter<DashboardState> emit) {
    log('on save result event ${event.todo}');
    state.todos.add(event.todo);
    emit(state.copyWith(todos: state.todos.toList()));
  }

  void _onLogoutEvent(Emitter<DashboardState> emit) async {
    await _sharedPref.setBool(SharedPrefKeys.loginSuccess, false);
    emit(state.copyWith(logOut: true));
  }
}
