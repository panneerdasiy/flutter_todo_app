import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screens/login/bloc/login_bloc.dart';
import 'package:todo_app/screens/login/bloc/login_events.dart';
import 'package:todo_app/screens/login/bloc/login_state.dart';
import 'package:todo_app/widgets/login_email_field.dart';
import 'package:todo_app/widgets/login_password_field.dart';
import 'package:todo_app/widgets/my_button.dart';

class LoginContent extends StatelessWidget {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final LoginBloc bloc;

  const LoginContent(this.bloc, this._emailController, this._passwordController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/login.jpg'),
        const SizedBox(height: 50),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.headline4,
            )),
        const SizedBox(height: 25),
        BlocBuilder<LoginBloc, LoginBlocState>(
          bloc: bloc,
            builder: (context, state) =>
                LoginEmailField(_emailController, error: state.emailError)),
        const SizedBox(height: 10),
        BlocBuilder<LoginBloc, LoginBlocState>(
            bloc: bloc,
            builder: (context, state) => LoginPasswordField(_passwordController,
                error: state.passwordError)),
        const SizedBox(height: 25),
        SizedBox(
            width: double.infinity,
            child:
                MyButton('Login', onPressed: () => _onLoginPressed(context))),
        const SizedBox(height: 10),
        const Text('OR'),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: MyButton('Login with Google',
              iconData: Icons.login, onPressed: () => _onLoginPressed(context)),
        )
      ],
    );
  }

  void _onLoginPressed(BuildContext context) {
    // LoginBloc bloc = context.read<LoginBloc>();
    String? email = _emailController.text;
    String? password = _passwordController.text;
    bloc.add(SubmitEvent(email: email, password: password));
  }
}
