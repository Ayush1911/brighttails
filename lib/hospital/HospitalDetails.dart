import 'dart:convert';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:http/http.dart' as http;
import 'package:brighttails/hospital/AppointmentForm.dart';
import 'package:brighttails/hospital/HospitalPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalDetails extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;

  HospitalDetails({super.key, this.GetData, this.imgurl});

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  int _currentIndex = 0;
  var hos_stime = "";
  var hos_day = "";
  var hos_etime = "";
  late Future<List<dynamic>?> alldata;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> hostimeData = [];
  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLHOSPITALTIMING);
  print("hid =${widget.GetData!["hospital_id"]}");
    try {
      var response = await http.post(
        url,
        body: {'hospital_id': widget.GetData!["hospital_id"]}, // Send the category ID properly
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("jsonData = ${jsonData["data"]}");
        setState(() {
          hostimeData = jsonData['data'];
          // print("hostimeData = ${hostimeData["time_id"]}");
          for (var item in hostimeData) {
            // print("time_id = ${item["time_id"]}");
            setState(() {
              hos_stime = item["start_time"];
              hos_etime = item["end_time"];
              hos_day = item["day"];

            });
          }
        });
        // return jsonData["data"]; // Assuming the data is in the "data" field
      } else {
        debugPrint("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    alldata = getdata(); // Now it works without an argument
  }
  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["logo"].toString(),
      widget.imgurl! + widget.GetData!["cover_image"].toString(),
      widget.imgurl! + widget.GetData!["image_1"].toString(),
      widget.imgurl! + widget.GetData!["image_2"].toString(),
      widget.imgurl! + widget.GetData!["image_3"].toString(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header with Back Button and Title
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1976d2), Color(0xffff8f00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                          MaterialPageRoute(builder: (context)=> HospitalPage())
                      );
                    },
                    icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Hospital Details",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Image Slider
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: imageList.map((imageUrl) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Hospital Details in List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    _buildSection(Icons.local_hospital, "Hospital Name", widget.GetData!["hospital_name"]),
                    _buildSection(Icons.info, "About Hospital", widget.GetData!["about_hospital"]),
                    _buildSection(Icons.medical_services, "Services", widget.GetData!["service"]),
                    _buildSection(Icons.location_on, "Address", widget.GetData!["address"]),
                    _buildSection(Icons.location_city, "City", widget.GetData!["city_name"]),
                    _buildSection(Icons.person, "Doctor's Name", widget.GetData!["doctors_name"]),
                    _buildSection(Icons.pin_drop, "Pincode", widget.GetData!["pincode"]),
                    _buildSection(Icons.my_location, "Latitude", widget.GetData!["latitude"]),
                    _buildSection(Icons.public, "Longitude", widget.GetData!["longitude"]),
                    _buildSection(Icons.check_circle, "Active Status", widget.GetData!["is_active"]),
                    _buildSection(Icons.phone, "Mobile", widget.GetData!["mobile"], ),
                    _buildSection(Icons.email, "Email", widget.GetData!["email"]),
                    _buildSection(Icons.language, "Website", widget.GetData!["website"]),
                    _buildSection(Icons.video_collection, "Video URL", widget.GetData!["video_url"]),
                    _buildSection(Icons.calendar_view_day, "Day", hos_day),
                    _buildSection(Icons.calendar_today, "Start Time", hos_stime),
                    _buildSection(Icons.calendar_today, "End Time", hos_etime),
                    // _buildSection(Icons.video_collection, "Video URL", hostimeData["time_id"].toString()),

                  ],
                ),
              ),
            ),

            // Submit Button at Bottom
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: InkWell(
                onTap: () {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AppointmentForm()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff2962ff), Color(0xff2962ff)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Appointment Form",
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildSection(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  value ?? "N/A",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }



  /// Function to build clickable links for mobile, email, website, and video
  Widget _buildClickable(String title, String? value, String prefix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              if (value != null && value.isNotEmpty) {
                launchUrl(Uri.parse(prefix.isEmpty ? value : "$prefix:$value"));
              }
            },
            child: Text(
              value ?? "N/A",
              style: TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
