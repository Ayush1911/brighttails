import 'package:brighttails/article/ArticlePage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Articledetails extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;
  Articledetails({super.key, this.GetData, this.imgurl});

  @override
  State<Articledetails> createState() => _ArticledetailsState();
}

class _ArticledetailsState extends State<Articledetails> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["article_image_1"].toString(),
      widget.imgurl! + widget.GetData!["article_image_2"].toString(),
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
                          MaterialPageRoute(builder: (context)=> Articlepage())
                      );
                    },
                    icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,),
                    // style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Articles Details",
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
                    _buildSection(Icons.title, "Title", widget.GetData!["title"]),
                    _buildSection(Icons.description, "Description", widget.GetData!["description"]),
                    _buildSection(Icons.book, "Article Reference", widget.GetData!["article_refrence"]),
                    _buildSection(Icons.person, "Author Name", widget.GetData!["author_name"]),
                    _buildSection(Icons.calendar_today, "Article DateTime", widget.GetData!["article_datetime"]),
                    _buildSection(Icons.verified, "Active Status", widget.GetData!["is_active"]),



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