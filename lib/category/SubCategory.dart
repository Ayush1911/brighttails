import 'dart:convert';

import 'package:brighttails/category/Category.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:brighttails/shop/ProductsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SubCategory extends StatefulWidget {
  final dynamic GetData;

  const SubCategory({super.key, this.GetData});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  late Future<List<dynamic>?> alldata;
  var img = UrlRescource.CATEGORYIMG;


  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLSUBCATEGORY);

    try {
      var response = await http.post(
        url,
        body: {'category_id': widget.GetData}, // Send the category ID properly
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData["data"]; // Assuming the data is in the "data" field
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
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: FutureBuilder( 
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Sub Category Found",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75, // ✅ Ensures proper spacing
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var subcategory = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductsPage(
                                GetData: subcategory["subcategory_id"].toString(),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.3),
                          child: Column(
                            children: [
                              Container(
                                width: 170, // ✅ Ensures uniform image height
                                height: 150, // ✅ Ensures uniform image height
                                padding: const EdgeInsets.all(2),
                                child: Image.network(
                                  img + subcategory["category_image"].toString(),
                                  width: double.infinity,
                                  fit: BoxFit.contain, // ✅ No more cropping!
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 10),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  subcategory["category_name"].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  subcategory["subcategory_name"].toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff1976d2), Color(0xffff8f00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Category()));
                },
                icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Text(
                "Sub Category List",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


}
