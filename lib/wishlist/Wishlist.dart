import 'dart:convert';

import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  late Future<List<dynamic>?> alldata;
  var img = UrlRescource.PRODUCTIMG;
  final TextEditingController _searchController = TextEditingController();

  get wishlist => null;

  Future<List<dynamic>?> getdata() async {
    print("Fetching wishlist data...");
    Uri url = Uri.parse(UrlRescource.ALLWISHLIST);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui = prefs.getString("userid") ?? "";

    var response = await http.post(
      url,
      body: {
        'user_id': ui,
      },
    );

    if (response.statusCode == 200) {
      var body = response.body.toString();
      var json = jsonDecode(body);

      if (json['status'] == "true") {
        return json['data'];
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    alldata = getdata();
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
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.bookmark_add_outlined, size: 100, color: Colors.blue),
                          SizedBox(height: 20),
                          Text(
                            "Your Wishlist is Empty",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    color: Colors.white, // White background for GridView
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var wishlist = snapshot.data![index];
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  img + wishlist["image_1"].toString(),
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                wishlist["title"].toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "₹ ${wishlist["sell_price"].toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      Uri url = Uri.parse(UrlRescource.DELEWISHLIST);
                                      var params = {
                                        "wishlist_id": wishlist["wishlist_id"].toString()
                                      };
                                      var response = await http.post(url, body: params);
                                      if (response.statusCode == 200) {
                                        var json = jsonDecode(response.body.toString());
                                        if (json["status"] == "true") {
                                          setState(() {
                                            alldata = getdata();
                                          });
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.delete_forever,
                                        color: Colors.red, size: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1976d2), Color(0xffff8f00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())),
            icon: const Icon(Icons.arrow_back, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 50),
          const Text(
            "Wishlist",
            style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
