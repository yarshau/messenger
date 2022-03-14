import 'package:flutter/material.dart';
import 'arguments.dart';
import 'package:yar_messenger/login_page.dart';
import 'routes.dart';
import 'package:yar_messenger/users_list_page.dart';

class PageRoutes {
  static MaterialPageRoute getPageRoute(String name, var arguments) {
    return MaterialPageRoute(builder: (context) {
      if (name == RoutesName.usersListPage) {
        var args = arguments as UsersListPageArgs;
        return UsersListPage(bloc: args.bloc);
      } else if (name == RoutesName.loginPage) {
        return LoginPage();
      } else if (name == RoutesName.signUpPage) {
        return const SignUpPage();
      }
      return LoginPage();
    });
  }
}
