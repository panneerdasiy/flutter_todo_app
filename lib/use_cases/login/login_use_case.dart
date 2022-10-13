import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/shared_pref_keys.dart';
import 'package:todo_app/use_cases/login/abstract_login_use_case.dart';
import 'package:todo_app/use_cases/login/login_result.dart';

class LoginUseCase implements AbstractLoginUseCase {
  final SharedPreferences _sharedPref;

  const LoginUseCase(this._sharedPref);

  @override
  Future<LoginResult> login(String email, String password) async {
    log('login = $email $password');
    bool isPasswordValid = _isPasswordValid(password);
    String? passwordError =
        isPasswordValid ? null : "Please enter a valid Password";

    if (!isPasswordValid) return LoginResult(false, message: passwordError);

    await _sharedPref.setBool(SharedPrefKeys.loginSuccess, true);
    return const LoginResult(true);
  }

  bool _isPasswordValid(String password) {
    log('isPasswordValid $password');
    if (password.isEmpty) return false;
    return password == "password";
  }

  @override
  bool isLoginSuccess() {
    return _sharedPref.getBool(SharedPrefKeys.loginSuccess) ?? false;
  }
}
