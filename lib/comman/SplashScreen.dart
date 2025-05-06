import 'dart:async';
import 'package:brighttails/auth/LoginPage.dart';
import 'package:brighttails/auth/SignUpPage.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("islogin")) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
    }
  }

  @override
  void initState() {
    super.initState();

    // print("hello ");
    Timer(Duration(seconds: 3), () {
      checklogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF3E0),
      body: Center(
        child: Image.asset(
          "assets/image/brighttails_app_logo.png",
        ),
      ),
    );
  }
}
