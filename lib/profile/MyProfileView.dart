import 'dart:convert';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileView extends StatefulWidget {
  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  late Future<List<dynamic>?> alldata;
  var img = UrlRescource.USERIMG;
  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  Future<List<dynamic>?> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui = prefs.getString("userid") ?? "";

    if (ui.isEmpty) {
      debugPrint("User ID is empty.");
      return [];
    }

    Uri url = Uri.parse(UrlRescource.ALLMYPROFILEVIEW);
    try {
      var response = await http.post(url, body: {"user_id": ui});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData["data"];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff1976d2), Color(0xffff8f00)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child:
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomePage()));
                    },
                    icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "My Profile ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Fetching and Displaying User Profile
            Expanded(
              child: FutureBuilder<List<dynamic>?>(
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Profile  Found"));
                  } else {
                    var userData = snapshot.data![0]; // Assuming first item contains user details

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        children: [
                          SizedBox(height: 20,),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: ClipOval(
                              child: userData["user_image"] != null
                                  ? Image.network(
                                img + userData["user_image"].toString(),
                                width: 100, // Ensure it covers the circular area
                                height: 100,
                                fit: BoxFit.cover, // Covers the circular shape properly
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              )
                                  : Icon(Icons.person, size: 50, color: Colors.grey),
                            ),
                          ),

                          SizedBox(height: 20,),
                          profileDetailRow("Name :", userData["name"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Email :", userData["email"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Mobile No :", userData["mobile"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("City Name :", userData["city_name"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Active Status :", userData["is_active"].toString()),
                          SizedBox(height: 20,),
                          profileDetailRow("Registered On :", userData["reg_date"].toString()),
                          SizedBox(height: 20,),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileDetailRow(String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 18, color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
