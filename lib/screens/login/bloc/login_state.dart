class LoginBlocState {
  final bool isLoading;
  final bool logInSuccess;
  final String? emailError;
  final String? passwordError;

  const LoginBlocState._internal({
    this.isLoading = false,
    this.logInSuccess = false,
    this.emailError,
    this.passwordError,
  });

  LoginBlocState copyWith({
    bool? isLoading,
    bool? logInSuccess,
    String? emailError,
    String? passwordError,
  }) {
    return LoginBlocState._internal(
      isLoading: isLoading ?? this.isLoading,
      logInSuccess: logInSuccess ?? this.logInSuccess,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  static LoginBlocState emailErr(String emailError) {
    return LoginBlocState._internal(
      emailError: emailError,
    );
  }

  static LoginBlocState passwordErr(String passwordError) {
    return LoginBlocState._internal(
      passwordError: passwordError,
    );
  }

  static LoginBlocState resetEmailErr(LoginBlocState state) {
    return LoginBlocState._internal(passwordError: state.passwordError);
  }

  static LoginBlocState resetPasswordErr(LoginBlocState state) {
    return LoginBlocState._internal(emailError: state.emailError);
  }

  static LoginBlocState loginSuccess() {
    return const LoginBlocState._internal(logInSuccess: true);
  }

  static LoginBlocState noState() {
    return const LoginBlocState._internal();
  }

  static LoginBlocState loading() {
    return const LoginBlocState._internal(isLoading: true);
  }
}
