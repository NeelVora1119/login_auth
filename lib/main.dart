import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/firebase_options.dart';

import 'package:login_auth/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LoginAuth());
}

class LoginAuth extends StatelessWidget {
  const LoginAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Signup(),
    );
  }
}
