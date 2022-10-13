import 'package:todo_app/screens/dashboard/bloc/todo.dart';

abstract class DetailsEvent {}

class UpdateEvent extends DetailsEvent {
  final String title;

  UpdateEvent(this.title);
}

class SaveEvent extends DetailsEvent {
  final String title;

  SaveEvent(this.title);
}

class DeleteEvent extends DetailsEvent {}
