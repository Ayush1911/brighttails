import 'package:brighttails/comman/HomePage.dart';
import 'package:flutter/material.dart';

class Animaldetails extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;


  Animaldetails({super.key, this.GetData, this.imgurl});

  @override
  State<Animaldetails> createState() => _AnimaldetailsState();
}

class _AnimaldetailsState extends State<Animaldetails> {
  // int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["animal_image"].toString(),

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
                    onPressed: () {Navigator.of(context).pop(
                        MaterialPageRoute(builder: (context)=> HomePage())
                    );},
                    icon: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Animals Details",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView(
                  children: [
                    SizedBox(height: 20,),
                    _buildText("Animal Name:", widget.GetData!["animal_name"]),
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
