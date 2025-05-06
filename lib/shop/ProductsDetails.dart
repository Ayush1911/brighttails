import 'dart:convert';
import 'dart:math';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:brighttails/shop/ProductsPage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsDetails extends StatefulWidget {
  final Map<String, dynamic>? GetData;
  final String? imgurl;

  ProductsDetails({super.key, this.GetData, this.imgurl});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  int _currentIndex = 0;
  int _quantity = 1; // Default quantity
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _loadWishlistStatus();
  }

  Future<void> _loadWishlistStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = widget.GetData!["product_id"].toString();
    bool status = prefs.getBool("wishlist_$pid") ?? false;
    setState(() {
      isWishlisted = status;
    });
  }
  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      widget.imgurl! + widget.GetData!["image_1"].toString(),
      widget.imgurl! + widget.GetData!["image_2"].toString(),
      widget.imgurl! + widget.GetData!["image_3"].toString(),
      widget.imgurl! + widget.GetData!["image_4"].toString(),
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
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Background color for IconButton
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                              builder: (context) => ProductsPage()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back,
                          size: 30, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Products Details",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  IconButton(
                    onPressed: () async {
                      var pid = widget.GetData!["product_id"].toString();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var ci = prefs.getString("userid").toString();
                      print("User ID = $ci");
                      print("Product ID = $pid");

                      // Determine the URL and message based on the current state
                      Uri url;
                      String successMessage;

                      if (isWishlisted) {
                        // Unbook (Delete from wishlist)
                        url = Uri.parse(UrlRescource.DELETEWISHLIST); // Update with your DELETE API endpoint
                        successMessage = "Removed from Wishlist";
                      } else {
                        // Book (Insert into wishlist)
                        url = Uri.parse(UrlRescource.INSERTWISHLIST); // Update with your INSERT API endpoint
                        successMessage = "Added to Wishlist";
                      }

                      var parms = {
                        "user_id": ci,
                        "product_id": pid,
                      };
                      print("Parameters = $parms");

                      try {
                        var response = await http.post(url, body: parms);
                        print("Response Code = ${response.statusCode}");
                        print("Response Body = ${response.body}");

                        if (response.statusCode == 200) {
                          var body = response.body.toString();
                          print("Response Body = $body");
                          var json = jsonDecode(body);

                          if (json["status"] == "true") {
                            var msg = json["messages"].toString();
                            print("Success Message: $msg");

                            // Toggle the wishlist status and update shared preferences
                            setState(() {
                              isWishlisted = !isWishlisted;
                            });
                            await prefs.setBool("wishlist_$pid", isWishlisted);

                            // Show a success message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(successMessage),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } else {
                            var msg = json["messages"].toString();
                            print("Error Message: $msg");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Operation failed: $msg"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          print("API Error: Status Code = ${response.statusCode}");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to connect to the server. Status Code: ${response.statusCode}"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        print("Exception: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Something went wrong. Please try again later."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      isWishlisted ? Icons.bookmark : Icons.bookmark_border,
                      size: 30,
                      color: isWishlisted ? Colors.red : Colors.white,
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
                          color: Color(0xffeeeeee),
                          child: Icon(Icons.broken_image,
                              size: 100, color: Colors.grey),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    _buildSection(Icons.shopping_bag, "Product Name :",
                        widget.GetData!["title"]),
                    _buildSection(Icons.description, "Description :",
                        widget.GetData!["description"]),
                    _buildSection(Icons.attach_money, "Retail Price:",
                        widget.GetData!["retail_price"]),
                    _buildSection(Icons.price_check, "Sell Price:",
                        widget.GetData!["sell_price"]),
                    _buildSection(Icons.category, "Subcategory:",
                        widget.GetData!["subcategory_name"]),
                    _buildSection(Icons.branding_watermark, "Brand:",
                        widget.GetData!["brand_name"]),
                    _buildSection(Icons.list_alt, "Specifications:",
                        widget.GetData!["specifications"]),
                    _buildSection(Icons.calendar_today, "Added DateTime:",
                        widget.GetData!["added_datetime"]),
                    _buildSection(Icons.toggle_on, "Active Status:",
                        widget.GetData!["is_active"]),
                    _buildSection(Icons.video_library, "Video Url:",
                        widget.GetData!["video_url"]),
                  ],
                ),
              ),
            ),

            // Submit Button at Bottom
            // Submit Button with TextField above it
            // Container for input field and button in one row

// Container for Quantity Input and Submit Button in One Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      // Border for styling
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Decrease Quantity Button

                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1)
                                _quantity--; // Prevent going below 1
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            color: Colors.blue,
                          ),
                        ),

                        // Quantity Display
                        Container(
                          width: 50, // F
                          // ixed width for the quantity field
                          child: TextField(
                            controller: TextEditingController(
                                text: _quantity.toString()),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none, // Remove default border
                            ),
                            onChanged: (value) {
                              setState(() {
                                _quantity = int.tryParse(value) ??
                                    1; // Handle invalid input
                                if (_quantity < 1)
                                  _quantity = 1; // Prevent negative values
                              });
                            },
                          ),
                        ),

                        // Increase Quantity Button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity++; // Increase count
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10), // Space between Quantity and Button

                  // Submit Button
                  InkWell(
                    onTap: () async {
                      // Handle submission with selected quantity
                      print("Selected Quantity: $_quantity");
                      Uri url = Uri.parse(UrlRescource.ADDTOCART);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var ui = prefs.getString("userid").toString();
                      print("userid = ${ui}");

                      print("uri = ${url}");

                      var price = int.parse(widget.GetData!["sell_price"]) *
                          int.parse(_quantity.toString());
                      var parms = {
                        "user_id": ui.toString(),
                        "product_id": widget.GetData!["product_id"].toString(),
                        "quantity": _quantity.toString(),
                        "price": price.toString(),
                      };
                      print("parms = ${parms}");

                      var responce = await http.post(url, body: parms);
                      print("responce = ${responce.statusCode}");

                      if (responce.statusCode == 200) {
                        var body = responce.body.toString();
                        print("body = ${body}");
                        var json = jsonDecode(body);
                        // print("json = ${json["data"]}");
                        if (json["status"] == "true") {
                          var msg = json["messages"].toString();
                          Fluttertoast.showToast(
                              msg: msg.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                        } else {
                          var msg = json["messages"].toString();
                          print(msg);
                          Fluttertoast.showToast(
                              msg: msg.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        // return json["data"];
                      } else {
                        print("Api Error!");
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff2962ff),
                            Color(0xff2962ff)
                          ], // Blue gradient effect
                        ),
                      ),
                      child: Text(
                        "Add To Cart",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
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
