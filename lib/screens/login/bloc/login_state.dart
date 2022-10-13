class LoginBlocState {
  final bool isLoading;
  final bool logInSuccess;
  final String? emailError;
  final String? passwordError;

  LoginBlocState({
    this.isLoading = false,
    this.logInSuccess = false,
    this.emailError,
    this.passwordError,
  });
}
