import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yar_messenger/user_model.dart';

class FirebaseApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<FirebaseResponse> createNewUser(String email, String password,
      String displayName, String phoneNumber, File? file) async {
    try {
      final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user = UserModel.fromFirebaseUser(newUser.user!);
      if (file != null) {
      String? photo = await addAvatarToStorage(file, user.uid);
        user.photoUrl = photo;
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toFireStore());

      print('user to string ${user.uid}');
      return user;
    } catch (error) {
      FireBaseResponseError onError = FireBaseResponseError(error.toString());
      print('You have got an error from FB when Register: ${error.toString()}');
      return onError;
    }
  }

  Future<FirebaseResponse> logInUser(String email, String password) async {
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      UserModel loggedUser = UserModel.fromFirebaseUser(user.user!);
      print('user to string FIREBASEAPI ${loggedUser.uid}');
      return loggedUser;
    } catch (error) {
      FireBaseResponseError onError = FireBaseResponseError(error.toString());
      print('You have got an error from FB when logIn: $error');
      return onError;
    }
  }

  Future<Object> getAllUsers() async {
    try {
      print('USERSLIST empty');
      QuerySnapshot<Map<String, dynamic>> users =
          await _firestore.collection('users').get();
      List<UserModel> myUsers =
          users.docs.map((user) => UserModel.fromJson(user.data())).toList();
      print('USERSLIST[0]: ${myUsers[0].toString()}');
      return users;
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future addAvatarToStorage(File? file, String userId) async {
    try {
      await _storage.ref('/avatars/$userId').putFile(file!);
      final sentImage = _storage.ref('/avatars/$userId').getDownloadURL();
      return sentImage;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future logOut() async {
    try {
      _auth.signOut();
      print('logOuted');
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future<void> sendMessage(String message) async {
    _firebaseDatabase.child('yar').set('yarVALUE');
    print('finish');
  }
}
