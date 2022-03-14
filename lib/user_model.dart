import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseResponse {}

class FireBaseResponseError extends FirebaseResponse {
  final String message;

  FireBaseResponseError(this.message);
}



class UserModel extends FirebaseResponse {
  final bool isNewUser;
  final String? displayName;
  final String? email;
  final bool isAnonymous;
  final String? phoneNumber;
  late final String? photoUrl;
  final String uid;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  final bool emailVerified;

//  final List<UserInfo> providerData;

  void set photourl(String photorl){
    photoUrl = photorl;
  }

  UserModel({
    this.isAnonymous = false,
    this.isNewUser = true,
    this.emailVerified = true,
    this.creationTime,
    this.lastSignInTime,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    required this.uid,
//    required this.providerData
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
        isNewUser: true,
        phoneNumber: user.phoneNumber,
        displayName: user.displayName,
        uid: user.uid,
        isAnonymous: user.isAnonymous,
        email: user.email,
        emailVerified: user.emailVerified,
        creationTime: user.metadata.creationTime,
        lastSignInTime: user.metadata.lastSignInTime);
  }

  factory UserModel.fromJson(user) {
    return UserModel(
        isNewUser: true,
        phoneNumber: user['phoneNumber'],
        displayName: user['displayName'],
        uid: user['uid'],
        isAnonymous: user['isAnonymous'],
        email: user['email'],
        photoUrl: user['photoURL'],
        emailVerified: user['emailVerified'],
        creationTime: Timestamp.now().toDate(),
        lastSignInTime: Timestamp.now().toDate());
  }

  Map<String, dynamic> toFireStore() {
    return {
      'isNewUser': isNewUser,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'uid': uid,
      'isAnonymous': isAnonymous,
      'email': email,
      'photoURL': photoUrl,
      'emailVerified': emailVerified,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime,
    };
  }

  @override
  String toString() {
    super.toString();
    return toFireStore().toString();
  }
}
