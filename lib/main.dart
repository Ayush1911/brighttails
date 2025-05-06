import 'package:brighttails/auth/LoginPage.dart';
import 'package:brighttails/auth/SignUpPage.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/comman/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrightTails',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
       
      home: SplashScreen(),
    );
  }
}


