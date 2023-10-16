import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/loginScreen.dart';

class HomePage extends StatefulWidget {
  final userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [
        IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.power_settings_new_outlined,
          ),
        )
      ]),
      body: Center(
        child: Text('Wellcome to Home Page , ${widget.userId}'),
      ),
    );
  }
}
