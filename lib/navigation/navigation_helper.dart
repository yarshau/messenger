import 'package:flutter/material.dart';
import 'arguments.dart';
import 'package:yar_messenger/login_cubit.dart';
import 'routes.dart';

class NavigationHelper {
  static Future openUsersListPage(
      {required BuildContext context, required LoginCubit bloc}) async {
    Navigator.of(context).pushReplacementNamed(RoutesName.usersListPage,
        arguments: UsersListPageArgs(bloc: bloc));
  }

  static Future openSignUpPage(BuildContext context) async {
    Navigator.of(context).pushNamed(RoutesName.signUpPage);
  }

  static Future back(BuildContext context) async {
    Navigator.pop(context);
  }

  static openLoginPage(BuildContext context) async {
    Navigator.of(context).pushReplacementNamed(RoutesName.loginPage);
  }
}
