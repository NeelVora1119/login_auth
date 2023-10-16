import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/home.dart';
import 'package:login_auth/loginScreen.dart';
import 'package:login_auth/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  User? user;
  String _email = "";
  String _pass = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent.shade200,
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Email";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextFormField(
              controller: _pwdController,
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Email";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _pass = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                print(_email);
                if (_formKey.currentState!.validate()) {
                  _handleSignup();
                }
              },
              child: const Text('SignUp'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
              child: const Text('Have Account?'),
            )
          ]),
        ),
      ),
    );
  }

  void _handleSignup() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
      user = userCredential.user;

      print('user registered ${userCredential.user!.email}');

      // Show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Successfully registered ${userCredential.user!.email}'),
          duration: const Duration(seconds: 2), // You can adjust the duration
        ),
      );
      // Navigate to another screen with user ID
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomePage(userId: userCredential.user!.email), // Pass user ID here
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);

      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
