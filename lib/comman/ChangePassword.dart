import 'dart:convert';
import 'package:brighttails/auth/LoginPage.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var formkey = GlobalKey<FormState>();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController conformpassword = TextEditingController();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff1976d2), Color(0xffff8f00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 25),
                            buildTextField("Old Password :", oldpassword, TextInputType.text,
                                Icons.lock, obscure: !oldPasswordVisible, toggleVisibility: () {
                                  setState(() {
                                    oldPasswordVisible = !oldPasswordVisible;
                                  });
                                }),
                            SizedBox(height: 25),
                            buildTextField("New Password :", newpassword, TextInputType.text,
                                Icons.lock_open, obscure: !newPasswordVisible, toggleVisibility: () {
                                  setState(() {
                                    newPasswordVisible = !newPasswordVisible;
                                  });
                                }),
                            SizedBox(height: 25),
                            buildTextField("Confirm Password :", conformpassword, TextInputType.text,
                                Icons.lock_reset, obscure: !confirmPasswordVisible, toggleVisibility: () {
                                  setState(() {
                                    confirmPasswordVisible = !confirmPasswordVisible;
                                  });
                                }),
                            SizedBox(height: 50),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // **Fixed Submission Issue**
                                  if (oldpassword.text.isEmpty ||
                                      newpassword.text.isEmpty ||
                                      conformpassword.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "All fields are required!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                    return; // Stop execution if any field is empty
                                  }

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var userId = prefs.getString("userid") ?? "";

                                  var params = {
                                    "oldpassword": oldpassword.text,
                                    "newpassword": newpassword.text,
                                    "conformpassword": conformpassword.text,
                                    "loginid": userId,
                                  };

                                  try {
                                    Uri url = Uri.parse(UrlRescource.CHANGEPASSWORD);
                                    var response = await http.post(url, body: params);

                                    print("Response: ${response.body}");

                                    if (response.statusCode == 200) {
                                      var responseBody = response.body.trim();

                                      if (responseBody.startsWith("{") && responseBody.endsWith("}")) {
                                        var json = jsonDecode(responseBody);

                                        Fluttertoast.showToast(
                                          msg: json["messages"] ?? "Unknown Response",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                        );

                                        // **Navigate only if API response is successful**
                                        if (json["status"] == "true") {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => HomePage()));
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Invalid API Response",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Server Error: ${response.statusCode}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                      );
                                    }
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                      msg: "Error: $e",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xff64b5f6), Color(0xff2962ff)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, TextInputType type,
      IconData icon, {bool obscure = false, required VoidCallback toggleVisibility}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        TextFormField(
          controller: controller,
          keyboardType: type,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: "Enter Your $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            prefixIcon: Icon(icon, color: Colors.blue),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
