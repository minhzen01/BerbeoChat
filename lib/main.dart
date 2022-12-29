import 'package:appchat/controllers/firebase_auth_controller.dart';
import 'package:appchat/views/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthController>(
            create: (_) => FirebaseAuthController())
      ],
      builder: (context, child) => MaterialApp(
        title: "AppChat",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "Baloo2",
            scaffoldBackgroundColor: Colors.white,
            backgroundColor: Colors.white),
        home: const MainScreen(),
      ),
    );
  }
}
