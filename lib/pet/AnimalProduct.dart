import 'dart:convert';

import 'package:brighttails/shop/ProductsDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../resources/UrlRescource.dart';

class AnimalProduct extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;

  const AnimalProduct({super.key, this.GetData, this.imgurl});

  @override
  State<AnimalProduct> createState() => _AnimalProductState();
}

class _AnimalProductState extends State<AnimalProduct> {
  late Future<List<dynamic>?> alldata;
  var img = UrlRescource.PRODUCTIMG;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? _allEvents; // All products from API
  List<dynamic>? _filteredEvents; // Filtered based on search input

  // Fetch data from API
  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLPRODUCT);

    try {
      var response = await http.post(
        url,
        body: {'product_id': widget.GetData}, // Send the category ID properly
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print("Decoded JSON type: ${jsonData.runtimeType}");
        print("Value: $jsonData");
        _allEvents = jsonData["data"];
        _filteredEvents = _allEvents;
        return _filteredEvents;
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
    alldata = getdata();
    _searchController.addListener(() {
      filterEvents(_searchController.text);
    });
  }

  // Filter events based on the search input
  void filterEvents(String query) {
    if (_allEvents == null) return;

    final filtered = _allEvents?.where((event) {
      final category = event["title"].toString().toLowerCase();
      return category.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredEvents = filtered;
    });
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
              child: FutureBuilder<List<dynamic>?>(
                future: alldata,  // Ensure alldata is assigned to the future function
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                    debugPrint("Snapshot Data: ${snapshot.data}"); // Log snapshot data for debugging
                    return const Center(
                      child: Text(
                        "No Products Found",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    );
                  }

                  // Set the filtered events from the data
                  List<dynamic> _filteredEvents = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _filteredEvents!.length,
                    itemBuilder: (context, index) {
                      var product =  _filteredEvents![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductsDetails(
                                GetData: product,
                                imgurl: img,
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
                                height: 120,
                                padding: const EdgeInsets.all(2),
                                child: Image.network(
                                  img + product["image_1"].toString(),
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  product["title"].toString(),
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


  // Top section with back button and search bar
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
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Text(
                "Products List",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  // Search bar for filtering products
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: "Search products...",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onChanged: (value) {
          debugPrint("Search: $value");
        },
      ),
    );
  }
}
