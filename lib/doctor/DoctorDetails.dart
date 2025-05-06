import 'package:brighttails/doctor/DoctorChat.dart';
import 'package:brighttails/doctor/DoctorPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DoctorDetails extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;

  DoctorDetails({super.key, this.GetData, this.imgurl});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["doctor_image"].toString(),

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
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),

                  ),
                  SizedBox(width: 20),
                  Text(
                    "Doctors Details",
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageList.isNotEmpty ? imageList[0] : 'https://via.placeholder.com/200',
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.contain, // Adjust fit property here
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),


            // Hospital Details in List
            // Doctor Details in List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    _buildSection(Icons.person, "Doctor Name:", widget.GetData!["doctor_name"]),
                    _buildSection(Icons.info, "About Doctor:", widget.GetData!["about"]),
                    _buildSection(Icons.school, "Education:", widget.GetData!["education"]),
                    _buildSection(Icons.business_center, "Experience:", widget.GetData!["experience"]),
                    _buildSection(Icons.attach_money, "Charges:", widget.GetData!["charges"]),
                    _buildSection(Icons.medical_services, "Specialization:", widget.GetData!["specialization"]),
                    _buildSection(Icons.phone, "Mobile:", widget.GetData!["mobile"]),
                    _buildSection(Icons.verified, "Active Status:", widget.GetData!["is_active"]),

                    SizedBox(height: 30),

                    // Stylish Chat Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DoctorChat()),
                          );
                        },
                        icon: Icon(Icons.chat_bubble_outline, size: 24),
                        label: Text(
                          "Chat with Doctor",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          backgroundColor: Color(0xff64b5f6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // Submit Button at Bottom

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

  // Helper Widget for Row Layout
  Widget _buildText(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 18, color: Colors.black),
          children: [
            TextSpan(
              text: label + " ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value.toString(),
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
