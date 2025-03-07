import 'dart:async';
import 'dart:convert';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  final String _keyEmail = 'email';
  final String _keyPassWord = 'password';
  final String _keyUserDetail = 'userDetail';

  Future setEmail(String email) async {
    await storage.write(key: _keyEmail, value: email);
  }

  Future setUser(UserModel user) async {
    await storage.write(key: _keyUserDetail, value: jsonEncode(user));
  }

  Future<UserModel?> getUser() async {
    final user = await storage.read(key: _keyUserDetail);
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user));
    } else {
      return Future.value(null);
    }
  }

  Future<String?> getEmail() async {
    return await storage.read(key: _keyEmail);
  }

  Future setPassWord(String password) async {
    await storage.write(
        key: _keyPassWord, value: Crypt.sha256(password).toString());
  }

  Future<void> deleteAll() async {
    await Future.wait([
      storage.delete(key: _keyEmail),
      storage.delete(key: _keyPassWord),
      storage.delete(key: _keyUserDetail)
    ]).onError((Object error, StackTrace stackTrace) {
      throw Exception("error in logout");
    });
  }

  Future<bool> checkPassWord(String password) async {
    final hashedPassword = await storage.read(key: _keyPassWord);
    if (hashedPassword != null) {
      final h = Crypt(hashedPassword);
      return h.match(password) ? true : false;
    } else {
      return false;
    }
  }
}
