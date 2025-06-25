import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cardy/home.dart';
import 'package:flutter_cardy/login.dart';
import 'package:flutter_cardy/register.dart';
import 'package:flutter_cardy/test.dart';

void main() async {
  // Code ไว้เชื่อม firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
      // home: Login(),
      // home: Register(),
      // home: AddUserScreen(),
    );
  }
}
