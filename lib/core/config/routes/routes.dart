import 'package:flutter/material.dart';
import 'package:cbc_app/presentation/screens/welcome/welcome_page.dart';

import 'package:cbc_app/presentation/screens/auth/register.dart';
import 'package:cbc_app/presentation/screens/auth/login.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      welcome: (context) => const WelcomePage(),
      register: (context) => const Register(),
      login: (context) => const Login(),
    };
  }
}
