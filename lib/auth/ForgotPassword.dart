import 'dart:convert';

import 'package:brighttails/auth/LoginPage.dart';
import 'package:brighttails/auth/OtpPage.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  var formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xfff8bbd0),
                // image: DecorationImage(
                //     image: AssetImage("assets/image/brighttails_app_logo.png"),
                //     // fit: BoxFit.fill,
                //     alignment: Alignment.topCenter
                // ),
              ),
            ),
            Positioned(
              top: 50,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,

                child: Image.asset("assets/image/brighttails_app_logo.png"),

               
              ),
            ),

            Positioned(
              top: 30,
              left: 2,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Loginpage()));
                      },
                      icon: Icon(Icons.arrow_back, size: 40, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),




            Positioned(
                top: 290,
                child: Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: Color(0xffeeeeee),
                    borderRadius: BorderRadius.circular(25)
                  ),
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
                              child: Text("Don't worry. Enter your email   " ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26,
                                ),),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Text("Email : ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val)
                                    {
                                      if (val == null || val.isEmpty) {
                                        return "Please enter Email";
                                      }
                                      // Regular expression for validating email format
                                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(val)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Enter Your Email",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0), // Optional: Rounded corners
                                        ),
                                        // enabledBorder: OutlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.blue, width: 2.0), // Default border color
                                        // ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 2.0), // Border color when focused
                                        ),
                                        prefixIcon: Icon(Icons.email,color: Colors.blue,)),
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
                                  print("object");
                                  var em = _email.text.toString(); // Get the email text
                                  Uri url = Uri.parse(UrlRescource.FORGOTPASSWORD); // API URL
                                  try {
                                    var response = await http.post(url, body: {
                                      "email": em,  // Use the email string
                                    });

                                    if (response.statusCode == 200) {
                                      var jsonResponse = jsonDecode(response.body);
                                      if (jsonResponse["status"] == "true") {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Password reset email sent successfully")),
                                        );
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>Loginpage())
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(jsonResponse["messages"])),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Server error. Please try again.")),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
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
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xfff8bbd0),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),


                          ],
                        )),
                  ),
                ))
          ],

        ),),

    );
  }
}
