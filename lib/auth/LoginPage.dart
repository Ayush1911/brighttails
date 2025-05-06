import 'dart:convert';

import 'package:brighttails/auth/OtpPage.dart';
import 'package:brighttails/auth/SignUpPage.dart';
import 'package:brighttails/auth/ForgotPassword.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff8bbd0),
              ),
            ),
            Positioned(
              top: 20,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/image/brighttails_app_logo.png"),
                // child: Image.asset("assets/image/app_logo.png"),
                decoration: BoxDecoration(
                  color: Color(0xfff8bbd0),
                  // image: DecorationImage(
                  //     image: AssetImage("assets/image/brighttails_app_logo.png"),
                  //     // fit: BoxFit.fill,
                  //     alignment: Alignment.topCenter
                  // ),
                ),
              ),
            ),
            Positioned(
                top: 240,
                child: Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xffeeeeee),
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                        key: formkey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                "Welcome To Login ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Email :",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please enter Email";
                                      }
                                      // Regular expression for validating email format
                                      if (!RegExp(
                                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                          .hasMatch(val)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Enter Your Email",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Optional: Rounded corners
                                        ),
                                        // enabledBorder: OutlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.blue, width: 2.0), // Default border color
                                        // ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black,
                                              width:
                                                  2.0), // Border color when focused
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.blue,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Password : ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: password,
                                    keyboardType: TextInputType.text,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Please enter password";
                                      }
                                      if (!RegExp(r'^\d{8}$').hasMatch(val)) {
                                        return "Password must be at least 8 characters long";
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Enter Your Password",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Optional: Rounded corners
                                        ),
                                        // enabledBorder: OutlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.blue, width: 2.0), // Default border color
                                        // ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black,
                                              width:
                                                  2.0), // Border color when focused
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.blue,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // Aligns content to the right
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Forgotpassword()));
                                  },
                                  child: Text(
                                    "Forgot Password ?",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                if (formkey.currentState!.validate()) {
                                  var em = email.text.toString();
                                  var pass = password.text.toString();

                                  var parms = {
                                    "email": em,
                                    "password": pass,
                                  };

                                  print("parms = ${parms}");
                                  // Uri url = Uri.parse("http://192.168.206.112/brighttails/api/register.php"); this is my phone ip address
                                  Uri url = Uri.parse(UrlRescource.LOGIN);

                                  print("uri = ${url}");
                                  var responce =
                                      await http.post(url, body: parms);
                                  print("responce = ${responce.statusCode}");

                                  if (responce.statusCode == 200) {
                                    // var body = responce.body.toString();
                                    // print("body = ${body}");
                                    var json = jsonDecode(responce.body.toString());
                                    print("json = ${json}");

                                    if (json["status"] == "true") {
                                      var msg = json["messages"].toString();
                                      print(msg);

                                      var id = json["data"]["user_id"].toString();
                                      var email = json["data"]["email"].toString();
                                      var mobile = json["data"]["mobile"].toString();
                                      var name = json["data"]["name"].toString();
                                      var img = json["data"]["user_image"].toString();
                                      var otpdata = json["data"]["otp"].toString();
                                      // print("id = ${id}");

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString("userid", id.toString());
                                      prefs.setString("useremail", email.toString());
                                      prefs.setString("usermobile", mobile.toString());
                                      prefs.setString("username", name.toString());
                                      prefs.setString("userimage", img.toString());
                                      prefs.setString("otpdata", otpdata.toString());
                                      prefs.setString("islogin", "yes");

                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context)=>Otppage())
                                      );
                                      Fluttertoast.showToast(
                                          msg: msg.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    } else {

                                      var msg = json["messages"].toString();
                                      print(msg);
                                      Fluttertoast.showToast(
                                          msg: msg.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }
                                  } else {
                                    print("Api Error!");
                                  }
                                }

                              },
                              child: Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xfff8bbd0),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                // Ensures minimal height
                                children: [
                                  Text(
                                    "Not have an account?",
                                    textAlign: TextAlign.center,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Signuppage()));
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
