import 'dart:convert';
import 'package:brighttails/hospital/HospitalPage.dart';
import 'package:http/http.dart' as http;
import 'package:brighttails/hospital/HospitalDetails.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  var formkey = GlobalKey<FormState>();
  TextEditingController startDateTime = TextEditingController();
  TextEditingController endDateTime = TextEditingController();
  TextEditingController userid = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController alternateMobile = TextEditingController();

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
                              Navigator.of(context).pop(MaterialPageRoute(builder: (context) => HospitalDetails()));
                            },
                            icon: Icon(Icons.arrow_back, size: 40, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Appointment ",
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 25),
                                buildDateTimeField("Start DateTime :", startDateTime),


                                SizedBox(height: 25),
                                buildDateTimeField("End DateTime :", endDateTime),

                                SizedBox(height: 25),
                                buildTextField("Message :", message, TextInputType.text, Icons.message, validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter a message";
                                  }
                                  if (val.length < 5) {
                                    return "Message should be at least 5 characters long";
                                  }
                                  return null;
                                }),

                                SizedBox(height: 30),
                                buildTextField("Alternate Mobile :", alternateMobile, TextInputType.phone, Icons.local_phone, validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please enter an alternate mobile number";
                                  }
                                  if (!RegExp(r'^[0-9]{10,15}$').hasMatch(val)) {
                                    return "Enter a valid phone number (10-15 digits)";
                                  }
                                  return null;
                                }),

                                SizedBox(height: 25),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formkey.currentState!.validate()) {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        var ui = prefs.getString("userid").toString();
                                        var params = {
                                          "start_datetime": startDateTime.text.toString(),
                                          "end_datetime": endDateTime.text.toString(),
                                          "user_id": ui,
                                          "message": message.text.toString(),
                                          "alternate_mobile": alternateMobile.text.toString()
                                        };

                                        Uri url = Uri.parse(UrlRescource.ADDAPPOINTMENT);
                                        var response = await http.post(url, body: params);

                                        if (response.statusCode == 200) {
                                          var json = jsonDecode(response.body.toString());
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context)=>HospitalPage())
                                          );
                                          Fluttertoast.showToast(
                                              msg: json["messages"].toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "API Error!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white);
                                        }
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
                                          "Book Appointment",
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
                  ),
                ),
                
              ],
            );
          },
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

