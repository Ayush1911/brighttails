import 'package:brighttails/category/Category.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/pet/AnimalProduct.dart';
import 'package:brighttails/pet/InquiryForm.dart';
import 'package:brighttails/pet/PetPage.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PetDetails extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;


  PetDetails({super.key, this.GetData, this.imgurl});

  @override
  State<PetDetails> createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["pet_image_1"].toString(),
      widget.imgurl! + widget.GetData!["pet_image_2"].toString(),
      widget.imgurl! + widget.GetData!["pet_image_3"].toString(),
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
                    "Pets Details",
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
                    _buildSection(Icons.pets, "Pet Name:", widget.GetData!["pet_name"]),
                    _buildSection(Icons.badge, "Breed Name:", widget.GetData!["breed_name"]),
                    _buildSection(Icons.forest, "Animal Name:", widget.GetData!["animal_name"]),
                    _buildSection(
                      widget.GetData!["gender"]?.toString().toLowerCase() == "male"
                          ? Icons.male
                          : widget.GetData!["gender"]?.toString().toLowerCase() == "female"
                          ? Icons.female
                          : Icons.transgender, // Default icon for unknown/other genders
                      "Gender:",
                      widget.GetData!["gender"] ?? "Unknown",
                    ),

                    _buildSection(Icons.monitor_weight, "Weight:", widget.GetData!["weight"]),
                    _buildSection(Icons.height, "Height:", widget.GetData!["hight"]),
                    _buildSection(Icons.color_lens, "Color:", widget.GetData!["color"]),
                    _buildSection(Icons.info_outline, "About Pets:", widget.GetData!["about"]),
                    _buildSection(Icons.toggle_on, "Active Status:", widget.GetData!["is_active"]),
                    _buildSection(Icons.video_library, "Video URL:", widget.GetData!["video_url"]),

                  ],
                ),
              ),
            ),

            // Submit Button at Bottom
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      height: 60,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Inquiryform()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff64b5f6), Color(0xff2962ff)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Inquiry Form",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      height: 60,
                      child: InkWell(
                        onTap: () {
                          print(widget.GetData!["animal_id"]);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Category(),
                            ),
                          );

                        },

                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff81c784), Color(0xff388e3c)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Shop",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )


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
