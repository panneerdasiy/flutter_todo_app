import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/use_cases/login/abstract_login_use_case.dart';
import 'package:todo_app/use_cases/login/login_result.dart';

import 'login_events.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginBlocState> {
  late AbstractLoginUseCase _useCase;

  set useCase(value) {
    _useCase = value;
    _onInitEvent();
  }

  LoginBloc() : super(LoginBlocState.loading()) {
    on<SubmitEvent>(_onLoginSubmit);
    on<EmailInput>(_onEmailInput);
    on<PasswordInput>(_onPasswordInput);
  }

  void _onLoginSubmit(event, emit) async {
    bool isEmailValid = _isEmailValid(event.email ?? "");
    String? emailError = isEmailValid ? null : "Please enter a valid Email ID";

    log('onLoginSubmit ${event.email}');
    if (!isEmailValid) {
      emit(LoginBlocState.emailErr(emailError!));
      return;
    }

    log('onLoginSubmit ${event.password}');
    LoginResult result = await _useCase.login(event.email, event.password);

    log('onLoginSubmit ${result.isSuccess} ${result.message}');
    emit(result.isSuccess
        ? LoginBlocState.loginSuccess()
        : LoginBlocState.passwordErr(result.message!));
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _onEmailInput(event, emit) {
    log('email reset');
    emit(LoginBlocState.resetEmailErr(state));
  }

  void _onPasswordInput(event, emit) {
    log('password reset');
    emit(LoginBlocState.resetPasswordErr(state));
  }

  void _onInitEvent() {
    bool loginSuccess = _useCase.isLoginSuccess();
    emit(loginSuccess
        ? LoginBlocState.loginSuccess()
        : LoginBlocState.noState());
  }
}
