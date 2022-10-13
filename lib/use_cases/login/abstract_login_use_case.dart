
import 'package:todo_app/use_cases/login/login_result.dart';

abstract class AbstractLoginUseCase{

  Future<LoginResult> login(String email, String password);

  bool isLoginSuccess();
}