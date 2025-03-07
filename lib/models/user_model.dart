import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? displayName;
  final String? email;
  final bool? isEmailVerified;
  final bool? isAnonymous;
  final String? phoneNumber;
  final String? photoUrl;
  final String? refreshToken;

  UserModel(
      {required this.uid,
      this.displayName,
      this.email,
      this.isEmailVerified,
      this.isAnonymous,
      this.phoneNumber,
      this.photoUrl,
      this.refreshToken});

  UserModel copyWith(
      {String? uid,
      String? displayName,
      String? email,
      bool? isEmailVerified,
      bool? isAnonymous,
      String? phoneNumber,
      String? photoUrl,
      String? refreshToken}) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        isEmailVerified: user.emailVerified,
        isAnonymous: user.isAnonymous,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
        refreshToken: user.refreshToken);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        displayName: json['displayName'],
        email: json['email'],
        isEmailVerified: json['isEmailVerified'],
        isAnonymous: json['isAnonymous'],
        phoneNumber: json['phoneNumber'],
        photoUrl: json['photoURL'],
        refreshToken: json['refreshToken']);
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'isEmailVerified': isEmailVerified,
        'isAnonymous': isAnonymous,
        'phoneNumber': phoneNumber,
        'photoUrl': photoUrl,
        'refreshToken': refreshToken,
      };
}
