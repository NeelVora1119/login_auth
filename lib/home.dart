import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  // User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    CollectionReference _users = FirebaseFirestore.instance.collection("users");

    return FutureBuilder(
      future: _users.doc(uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          Text('Something Went Wrong...!!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.data == null) {
          return Text('No Data Found...!!!');
        }

        if (snapshot != null && snapshot.data != null) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  'Home',
                ),
                actions: [
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
            body: Container(
              child: Column(
                children: [
                  Text(data['age'].toString()),
                  Text(data['gender'].toString()),
                  Text(data['email'].toString()),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
