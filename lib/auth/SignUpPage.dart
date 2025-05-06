
import 'dart:convert';
import 'dart:io';
import 'package:brighttails/auth/LoginPage.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  var formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  File? photo1 = null;
  // TextEditingController cpassword = TextEditingController();
  List<dynamic> cityData = [];
  var city;
  Future<List<dynamic>?>? alldata;
  var img = UrlRescource.USERIMG;
  Future<List<dynamic>?>? getcitydata()async{
    Uri uri = Uri.parse(UrlRescource.ALLCITYDATA);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        cityData = body['data'];
        print("cityData $cityData");
      });
    } else {
      print("api error");
    }
  }

  @override
  void initState() {
    super.initState();
    getcitydata();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff8bbd0),

                  ),
                ),
                Positioned(
                  // top: 1,
                  child: Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width,

                    child: Image.asset("assets/image/brighttails_app_logo.png"),

                  ),
                ),
                Positioned(
                  top: 165,


                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight - 160,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: MediaQuery.of(context).size.width,

                        decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(25)
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Create Your Account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 26),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  buildTextField("Name :", name, TextInputType.name, Icons.account_circle, validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please enter Name";
                                    }
                                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
                                      return "Name should contain only letters";
                                    }
                                    return null;
                                  }),
                                  SizedBox(height: 5),
                                  buildTextField("Email :", email, TextInputType.emailAddress, Icons.email, validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please enter Email";
                                    }
                                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(val)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  }),
                                  SizedBox(height: 5),
                                  buildTextField("Contact Number :", mobile, TextInputType.phone, Icons.local_phone, validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please enter mobile";
                                    }
                                    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(val)) {
                                      return "Enter a valid phone number";
                                    }
                                    return null;
                                  }),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Select City:", style: TextStyle(fontSize: 18, )),
                                        SizedBox(height: 5),
                                        cityData.isNotEmpty
                                            ? DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                            prefixIcon: Icon(Icons.location_city, color: Colors.blue),
                                            hintText: "Select your city",
                                          ),
                                          value: city != null && city.toString().isNotEmpty ? city : null,
                                          items: cityData.map((value) {
                                            return DropdownMenuItem<String>(
                                              value: value['city_id'],
                                              child: Text(value['city_name']),
                                            );
                                          }).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              city = val!;
                                            });
                                          },
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "User Image:",
                                    style: TextStyle(fontSize: 18),
                                  ),

                                  SizedBox(height: 10),

                                  GestureDetector(
                                    onTap: () async {
                                      final ImagePicker _picker = ImagePicker();
                                      XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                                      if (photo != null) {
                                        setState(() {
                                          photo1 = File(photo.path);
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.image, color: Colors.blue),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              photo1 != null ? photo1!.path.split("/").last : "Select Image",
                                              style: TextStyle(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  if (photo1 != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        photo1!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  SizedBox(height: 5),
                                  buildTextField("Password :", password, TextInputType.text, Icons.lock, obscure: true, validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please enter password";
                                    }
                                    if (val.length < 8) {
                                      return "Password must be at least 8 characters long";
                                    }
                                    return null;
                                  }),
                                  InkWell(
                                    onTap: () async {
                                      if (formkey.currentState!.validate()) {
                                        var nm = name.text.toString();
                                        var em = email.text.toString();
                                        var mo = mobile.text.toString();
                                        var pass = password.text.toString();

                                        Uri url = Uri.parse(UrlRescource.REGISTER);
                                        var request = http.MultipartRequest("POST", url);
                                        request.fields['name'] = nm;
                                        request.fields['email'] = em;
                                        request.fields['mobileno'] = mo;
                                        request.fields['password'] = pass;
                                        request.fields['city_id'] = city.toString();

                                        print("Image: ${photo1!.path}");

                                        var stream = http.ByteStream(photo1!.openRead());
                                        var length = await photo1!.length();

                                        var multipartFile = http.MultipartFile(
                                          'user_image',
                                          stream,
                                          length,
                                          filename: photo1!.path.split("/").last,
                                        );

                                        request.files.add(multipartFile);

                                        var response = await request.send();

                                        var responseBody = await http.Response.fromStream(response);
                                        print("Response Code: ${response.statusCode}");
                                        print("Response Body: ${responseBody.body}");

                                        if (response.statusCode == 200) {

                                          if (responseBody.body.trim() == "yes") {
                                            print("Data inserted successfully");
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => Loginpage()),
                                            );
                                          } else {
                                            print("Data not inserted");
                                          }
                                        } else {
                                          print("Error: ${response.statusCode}");
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(15),
                                      padding: EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff8bbd0),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),

                                  Center(
                child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text("Already have an account? "),
                InkWell(
                onTap: () {
                Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> Loginpage())
                );
                },
                child: Text(
                "Login",
                style: TextStyle(color: Colors.black),
                ),
                ),
                ],
                ),
                ),
                ],

                              ),
                            ),
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

  Widget buildTextField(String label, TextEditingController controller, TextInputType type, IconData icon, {bool obscure = false,FormFieldValidator? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        TextFormField(
          controller: controller,
          keyboardType: type,

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
