import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/home.dart';
import 'package:login_auth/sign_up.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwdController = TextEditingController();
  String _email = "";
  String _pass = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _emailController,
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
                  return "Please Enter Password";
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
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                   
                    MaterialPageRoute(
                      builder: (context) => const Signup(),
                    ));
              },
              child: const Text('Create Account?'),
            )
          ]),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _pwdController.text,
        );

        if (userCredential.user != null) {
          print('User signed in: ${userCredential.user!.email}');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  HomePage(),
            ),
          );
        } else {
          print('User is null.');
          // Handle the case where user is unexpectedly null
        }
      } on FirebaseAuthException catch (e) {
        print('Error: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
