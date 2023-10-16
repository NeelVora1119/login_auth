import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_auth/dummy.dart';

import 'package:login_auth/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  TextEditingController _ageController = TextEditingController();
  // TextEditingController _selectedCountryController = TextEditingController();
  User? user;
  String _email = "";
  String _pass = "";
  String _gender = "";

  String _selectedCountry = "Country A"; // initial value

  var _isAuthenticating = false;
  List<String> countries = ["Country A", "Country B", "Country C"];
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
            Row(
              children: [
                Text('Gender:'),
                Radio(
                  activeColor: Colors.black,
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  activeColor: Colors.black,
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Age";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              hint: Text('Please choose a country'),
              value: _selectedCountry,
              onChanged: (newValue) {
                setState(() {
                  _selectedCountry = newValue.toString();
                });
              },
              items: countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (_isAuthenticating) const CircularProgressIndicator(),
            if (!_isAuthenticating)
              ElevatedButton(
                onPressed: _handleSignup,
                child: const Text('Signup'),
              ),
            if (!_isAuthenticating)
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
      setState(() {
        _isAuthenticating = true;
      });
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
      user = userCredential.user;

      print('user registered ${userCredential.user!.email}');

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': _email,
        'gender': _gender,
        'age': int.parse(_ageController.text),
        'country': _selectedCountry,
        // Add more fields as needed
      });

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
      setState(() {
        _isAuthenticating = false;
      });
    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.message}');
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      print('Firestore Write Error: $e');
      setState(() {
        _isAuthenticating = false;
      });
    }
  }
}
