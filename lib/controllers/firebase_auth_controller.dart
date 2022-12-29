import 'dart:async';
import 'dart:io';
import 'package:appchat/data_sources/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/app_user.dart';
import '../resources/utils/utils.dart';

enum AuthStatus { none, authenticate, unauthenticate }

class FirebaseAuthController with ChangeNotifier {
  AuthStatus authStatus = AuthStatus.none;

  final FirebaseServices _firebaseService = FirebaseServices();
  late StreamSubscription _authStreamSubscription;

  AppUser? appUser;
  bool isLoading = false;

  FirebaseAuthController() {
    _init();
  }

  void _init() {
    _authStreamSubscription =
        _firebaseService.userChangeStream().listen((user) async {
      if (user != null) {
        await _firebaseService.getUser(user.uid).then((value) async {
          if (value != null) {
            appUser = value;
            authStatus = AuthStatus.authenticate;
          }
        });
      } else {
        appUser = null;
        authStatus = AuthStatus.unauthenticate;
      }
      notifyListeners();
    });
  }

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    _loading();
    await _firebaseService.signInWithEmailAndPassword(
        email: email, password: password);
    _unLoading();
  }

  Future signInWithGoogle() async {
    _loading();
    await _firebaseService.signInWithGoogle();
    _unLoading();
  }

  Future<bool> createAccount(
      {required String name,
      required String email,
      required String password,
      required File? file}) async {
    bool created = false;
    _loading();
    await _firebaseService.createAccountWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        avatar: file,
        onDone: (user) {
          appUser = user;
          authStatus = AuthStatus.authenticate;
          _unLoading();
          created = true;
        },
        onError: () {
          created = false;
        });
    _unLoading();
    return created;
  }

  Future signOut() async {
    _loading();
    await _firebaseService.signOut();
    _unLoading();
  }

  Future<bool> updateUser(
      {required String displayName, required File? avatar}) async {
    _loading();
    try {
      await _firebaseService.updateUser(
          userId: appUser!.uid!,
          displayName:
              displayName.isEmpty ? appUser!.displayName! : displayName,
          avatar: avatar);
      appUser = await _firebaseService.getUser(appUser!.uid!);
      Utils.showToast("Cập nhật thông tin người dùng thành công !");
      _unLoading();
      return true;
    } on FirebaseException catch (e) {
      _unLoading();
      Utils.showToast(e.message ?? "");
      return false;
    }
  }

  _loading() {
    isLoading = true;
    notifyListeners();
  }

  _unLoading() {
    isLoading = false;
    notifyListeners();
  }
}
