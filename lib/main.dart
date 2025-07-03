import 'package:flutter/material.dart';
import 'package:rive_teddy_bear/screens/bunny_login.dart';
import 'package:rive_teddy_bear/screens/kochalo_login.dart';
import 'package:rive_teddy_bear/screens/man_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Login Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ManLoginScreen(),
    );
  }
}
