import 'package:flutter/material.dart';
import 'package:yar_messenger/login_cubit.dart';
import 'package:yar_messenger/navigation/navigation_helper.dart';

class UsersListPage extends StatefulWidget {
  LoginCubit bloc;

  UsersListPage({Key? key, required this.bloc}) : super(key: key);

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  late LoginCubit _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _bloc.getUsersEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text('UserList'), actions: [
          IconButton(
            onPressed: () {
              _bloc.logOut();
              NavigationHelper.openLoginPage(context);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ]),
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(_bloc.user.uid),
              );
            }),
      ),
    );
  }
}
