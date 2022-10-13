
abstract class LoginEvent {}

class SubmitEvent extends LoginEvent {
  String? email;
  String? password;

  SubmitEvent({this.email, this.password});
}

class EmailInput extends LoginEvent {}

class PasswordInput extends LoginEvent {}