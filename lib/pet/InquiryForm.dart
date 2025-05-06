import 'dart:convert';

import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/pet/PetDetails.dart';
import 'package:brighttails/pet/PetPage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Inquiryform extends StatefulWidget {
  const Inquiryform({super.key});

  @override
  State<Inquiryform> createState() => _InquiryformState();
}

class _InquiryformState extends State<Inquiryform> {
  var formkey = GlobalKey<FormState>();

  TextEditingController userid = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController inqdatetime = TextEditingController();
  TextEditingController status = TextEditingController();
  List<dynamic> petData = [];
  var pet;
  Future<List<dynamic>?>? alldata;
  Future<List<dynamic>?>? getpetData()async{
    Uri uri = Uri.parse(UrlRescource.ALLPET);
    var responce = await http.get(uri);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      print("body = ${body}");
      setState(() {
        petData = body['data'];
        print("petdata = ${petData}");
      });
    } else {
      print("api error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldata =  getpetData();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1976d2), Color(0xffff8f00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                          MaterialPageRoute(builder: (context) => PetDetails()));
                    },
                    icon: Icon(Icons.arrow_back, size: 40, color: Colors.white,),
                  ),
                  SizedBox(width: 40),
                  Text(
                    "Inquiry ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // **Expanded Section for Inquiry Form**
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffeeeeee),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),

                          // **Dropdown for Selecting Pets**
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Pets:",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                petData.isNotEmpty
                                    ? DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                    prefixIcon: Icon(Icons.pets, color: Colors.blue),
                                    hintText: "Select your Pets",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  value: pet != null && pet.toString().isNotEmpty ? pet : null,
                                  items: petData.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value['pet_id'],
                                      child: Text(value['pet_name']),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      pet = val!;
                                    });
                                  },
                                )
                                    : Container(),
                              ],
                            ),
                          ),

                          SizedBox(height: 35),
                          buildTextField("Message :", message, TextInputType.text, Icons.message, validator: (val) {
                            if (val == null || val.isEmpty) return "Please enter a message";
                            if (val.length < 5) return "Message should be at least 5 characters long";
                            return null;
                          }),
                          SizedBox(height: 35),
                          buildDateTimeField("Inquiry DateTime :", inqdatetime),

                          SizedBox(height: 35),
                          buildTextField("Status :", status, TextInputType.text, Icons.info,
                              validator: (val) {
                                if (val == null || val.isEmpty) return "Please enter a status";
                                if (val.length < 3) return "Status must be at least 3 characters long";
                                if (val.length > 50) return "Status should not exceed 50 characters";
                                return null;
                              }),

                          SizedBox(height: 35),

                          // **Inquiry Button**
                          InkWell(
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
                                var inq = inqdatetime.text.toString();
                                var me = message.text.toString();
                                var sa = status.text.toString();

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                var ui = prefs.getString("userid").toString();

                                var parms = {
                                  "user_id": ui,
                                  "pet_id": pet.toString(),
                                  "message": me,
                                  "inq_datetime": inq,
                                  "status": sa
                                };

                                Uri url = Uri.parse(UrlRescource.ADDINQUIRY);
                                var response = await http.post(url, body: parms);

                                if (response.statusCode == 200) {
                                  var json = jsonDecode(response.body.toString());
                                  if (json["status"] == "true") {
                                    print(json["messages"].toString());
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => HomePage()),
                                    );
                                    Fluttertoast.showToast(
                                      msg: json["messages"].toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                    );
                                  } else {
                                    print(json["messages"].toString());
                                    Fluttertoast.showToast(
                                      msg: json["messages"].toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                    );
                                  }
                                } else {
                                  print("API Error: ${response.statusCode}");
                                  Fluttertoast.showToast(
                                    msg: "API Error!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            },

                            child: Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(
                                "Inquiry",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xff64b5f6), Color(0xff2962ff)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildDateTimeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            DateTime? dateTime = await showOmniDateTimePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now().add(Duration(days: 365)),
            );
            if (dateTime != null) {
              setState(() {
                controller.text = dateTime.toString();
              });
            }
          },
          decoration: InputDecoration(
            hintText: "Select DateTime",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller, TextInputType type, IconData icon, {bool obscure = false, FormFieldValidator<String>? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        TextFormField(
          controller: controller,
          keyboardType: type,
          // maxLines: ,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: "Enter Your $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
            prefixIcon: Icon(icon, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
