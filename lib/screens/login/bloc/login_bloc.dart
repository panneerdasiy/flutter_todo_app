import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/shared_pref_keys.dart';

import 'login_events.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginBlocState> {
  late SharedPreferences _sharedPref;

  set sharedPref(value) {
    log('sharedPref received');
    _sharedPref = value;
    _onSharedPrefReceived();
  }

  LoginBloc() : super(LoginBlocState(isLoading: true)) {
    on<SubmitEvent>(_onLoginSubmit);
    on<EmailInput>(_onEmailInput);
    on<PasswordInput>(_onPasswordInput);
  }

  void _onLoginSubmit(event, emit) async {
    bool isEmailValid = _isEmailValid(event.email ?? "");
    String? emailError = isEmailValid ? null : "Please enter a valid Email ID";

    bool isPasswordValid = _isPasswordValid(event.password);
    String? passwordError =
        isPasswordValid ? null : "Please enter a valid Password";

    bool logInSuccess = isEmailValid && isPasswordValid;
    if (logInSuccess) await _sharedPref.setBool(SharedPrefKeys.loginSuccess, true);

    emit(LoginBlocState(
      isLoading: false,
      logInSuccess: logInSuccess,
      emailError: emailError,
      passwordError: passwordError,
    ));
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    return password == "password";
  }

  void _onEmailInput(event, emit) {
    emit(LoginBlocState(
      isLoading: false,
      logInSuccess: false,
      passwordError: state.passwordError,
    ));
  }

  void _onPasswordInput(event, emit) {
    emit(LoginBlocState(
      isLoading: false,
      logInSuccess: false,
      emailError: state.emailError,
    ));
  }

  void _onSharedPrefReceived() {
    emit(LoginBlocState(
      isLoading: false,
      logInSuccess: _sharedPref.getBool('logInSuccess') ?? false,
    ));
  }
}
