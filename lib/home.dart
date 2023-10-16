import 'package:flutter/material.dart';

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
      appBar: AppBar(
          title: Text('Home'),
          actions: [Icon(Icons.power_settings_new_outlined)]),
      body: Center(
        child: Text('Wellcome to Home Page , ${widget.userId}'),
      ),
    );
  }
}
