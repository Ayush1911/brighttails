import 'dart:convert';
import 'package:brighttails/category/SubCategory.dart';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:brighttails/shop/ProductsDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
class ProductsPage extends StatefulWidget {

  final dynamic GetData;

  const ProductsPage({super.key, this.GetData});
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';

  late Future<List<dynamic>?> alldata;
  var img = UrlRescource.PRODUCTIMG;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? _allEvents; // All events from API
  List<dynamic>? _filteredEvents; // Filtered based on search input
  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLPRODUCT);

    try {
      var response = await http.post(
        url,
        body: {'subcategory_id': widget.GetData}, // Send the category ID properly
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
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
    _speech = stt.SpeechToText();
    alldata = getdata();
    _searchController.addListener(() {
      filterEvents(_searchController.text);
    });
  }
  void filterEvents(String query) {
    final filtered = _allEvents?.where((event) {
      final category = event["title"].toString().toLowerCase();
      return category.contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredEvents = filtered;
    });
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _searchText = val.recognizedWords;
            _searchController.text = _searchText;
            filterEvents(_searchText);
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
                        "No Products Found",
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
                    itemCount: _filteredEvents!.length,
                    itemBuilder: (context, index) {
                      var product = _filteredEvents![index];
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
                                height: 120, // ✅ Ensures uniform image height
                                padding: const EdgeInsets.all(2),
                                child: Image.network(
                                  img + product["image_1"].toString(),
                                  width: double.infinity,
                                  fit: BoxFit.contain, // ✅ No more cropping!
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

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color:
                    _isListening ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: _listen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),

        ),
      ],
    );
  }
}
