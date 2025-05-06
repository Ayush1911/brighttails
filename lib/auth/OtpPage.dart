import 'package:brighttails/comman/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart'; // Update path as per your project

class Otppage extends StatefulWidget {
  const Otppage({super.key});

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> {
  var otp ;
TextEditingController txtotp = TextEditingController();
  getotp()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      otp = prefs.getString("otpdata").toString();
      print("otp = ${otp}");
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getotp().then((val){
      Fluttertoast.showToast(
          msg: otp,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 50,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 30.0
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff), // Pink background
      body: SafeArea(
        child: Stack(
          children: [
            /// Back Button


            /// Main OTP Box
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset("assets/image/Animation.gif", height: 120),
                      const SizedBox(height: 20),
                      const Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please enter the 6-digit code \nsent to your email shortly",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 25),

                      /// OTP Input
                      PinCodeTextField(
                        controller: txtotp,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.phone, // <-- Fixed here
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          inactiveColor: Colors.grey,
                          selectedColor: Colors.green,
                          activeColor: Colors.green,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.white,
                        enableActiveFill: true,
                        appContext: context,
                      ),

                      const SizedBox(height: 50),

                      /// Submit Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              var otpdata = txtotp.text.toString();

                              print("otpdata = $otpdata");
                              print("otp = $otp");

                              if (otpdata == otp) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please enter a valid 6-digit OTP or Otp Not Match!"),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            ),
                            child: const Text(
                              "Home",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              txtotp.clear(); // Or navigate to Otppage if that's your intent
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            ),
                            child: const Text(
                              "Reset",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


