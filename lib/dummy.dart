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



// ********************************



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({
//     super.key,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _userStream =
//       FirebaseFirestore.instance.collection('users').snapshots();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: StreamBuilder(
//         stream: _userStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text('Connection Error');
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text('Loading....');
//           }
          


//           var docs = snapshot.data!.docs;

//           return Text('${docs.length}');

          
//         },
//       ),
//     );
//   }
// }
