import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yar_messenger/firebase_api.dart';
import 'package:yar_messenger/user_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  final FirebaseApi _firebaseApi;

  LoginCubit(this._firebaseApi) : super(LoginInitial());
  late final UserModel user;
  late List users;

  void createNewUserEvent(String email, String password, String displayName,
      String phoneNumber, File? file) async {
    final FirebaseResponse userlogin = await _firebaseApi.createNewUser(
        email, password, displayName, phoneNumber, file);
    if (userlogin is UserModel) {
      user = userlogin;
      emit(LoggedSuccessState(user));
    } else if (userlogin is FireBaseResponseError) {
      emit(LoggedErrorState(userlogin.message));
    }
  }

  void logInUserEvent(String email, String password) async {
    final FirebaseResponse userlogin =
        await _firebaseApi.logInUser(email, password);
    if (userlogin is UserModel) {
      user = userlogin;
      print ('from bloc ${user.uid}');
      emit(LoggedSuccessState(userlogin));
    } else if (userlogin is FireBaseResponseError) {
      emit(LoggedErrorState(userlogin.message));
    }
  }

  void getUsersEvent() async {
    await _firebaseApi.getAllUsers();
  }

  void logOut() async{
    await _firebaseApi.logOut();
  }
}

abstract class LoginStates extends Equatable {}

class LoginInitial extends LoginStates {
  @override
  List<Object?> get props => [];
}

class LoggedSuccessState extends LoginStates {
  final UserModel user;

  LoggedSuccessState(this.user);

  @override
  List<Object?> get props => [];
}

class LoggedErrorState extends LoginStates {
  final String error;

  LoggedErrorState(this.error);

  @override
  List<Object?> get props => [];
}
class ImageAddedState extends LoginStates {
  @override
  List<Object?> get props => [];

}
