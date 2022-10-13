import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/routes.dart';
import 'package:todo_app/screens/login/bloc/login_bloc.dart';
import 'package:todo_app/screens/login/bloc/login_events.dart';
import 'package:todo_app/screens/login/bloc/login_state.dart';
import 'package:todo_app/use_cases/login/login_use_case.dart';
import 'package:todo_app/widgets/login_email_field.dart';
import 'package:todo_app/widgets/login_password_field.dart';
import 'package:todo_app/widgets/my_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginBloc bloc = LoginBloc();

  @override
  void initState() {
    _emailController.addListener(_emailFieldListener);
    _passwordController.addListener(_passwordFieldListener);
    SharedPreferences.getInstance()
        .then((value) => bloc.useCase = LoginUseCase(value));
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: BlocListener<LoginBloc, LoginBlocState>(
                  bloc: bloc,
                  listener: (context, state) {
                    if (state.logInSuccess) {
                      _onLoginSuccess(context);
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginBlocState>(
                    bloc: bloc,
                    buildWhen: (then, now) => then.isLoading != now.isLoading,
                    builder: (context, state) => state.isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/login.jpg'),
                              const SizedBox(height: 50),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Login',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  )),
                              const SizedBox(height: 25),
                              BlocBuilder<LoginBloc, LoginBlocState>(
                                  bloc: bloc,
                                  buildWhen: (then, now) =>
                                      then.emailError != now.emailError,
                                  builder: (context, state) => LoginEmailField(
                                      _emailController,
                                      error: state.emailError)),
                              const SizedBox(height: 10),
                              BlocBuilder<LoginBloc, LoginBlocState>(
                                  bloc: bloc,
                                  buildWhen: (then, now) =>
                                      then.passwordError != now.passwordError,
                                  builder: (context, state) =>
                                      LoginPasswordField(_passwordController,
                                          error: state.passwordError)),
                              const SizedBox(height: 25),
                              SizedBox(
                                  width: double.infinity,
                                  child: MyButton('Login',
                                      onPressed: _onLoginPressed)),
                              const SizedBox(height: 10),
                              const Text('OR'),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: MyButton('Login with Google',
                                    iconData: Icons.login,
                                    onPressed: _onLoginPressed),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    String? email = _emailController.text;
    String? password = _passwordController.text;
    bloc.add(SubmitEvent(email: email, password: password));
  }

  void _emailFieldListener() {
    bloc.add(EmailInput());
  }

  void _passwordFieldListener() {
    bloc.add(PasswordInput());
  }

  void _onLoginSuccess(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Login Success")));
    Navigator.of(context).popAndPushNamed(Routes.dashboard);
  }
}
