import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/firebase_auth_controller.dart';
import '../../resources/widgets/auth/body_sign_in.dart';
import '../../resources/widgets/auth/header_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const HeaderSignIn(),
                  BodySignIn(
                      emailEditingController: emailEditingController,
                      passwordEditingController: passwordEditingController
                  ),
                ],
              ),
            ),
          ),
        ),
        if (context.watch<FirebaseAuthController>().isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
