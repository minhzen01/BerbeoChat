import 'package:appchat/controllers/firebase_auth_controller.dart';
import 'package:appchat/views/auth/sign_in_screen.dart';
import 'package:appchat/views/home_screen.dart';
import 'package:appchat/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.watch<FirebaseAuthController>().authStatus;
    switch (status) {
      case AuthStatus.authenticate:
        return const HomeScreen();
      case AuthStatus.unauthenticate:
        return const SignInScreen();
      default:
        return const SplashScreen();
    }
  }
}
