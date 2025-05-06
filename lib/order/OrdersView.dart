import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../resources/UrlRescource.dart';

class Ordersview extends StatefulWidget {
  final Map<String, dynamic>? GetData;

  const Ordersview({super.key, this.GetData});

  @override
  State<Ordersview> createState() => _OrdersviewState();
}

class _OrdersviewState extends State<Ordersview> {
  Future<List<dynamic>>? alldata;
  int selectedTab = 0; // 0 for Items Details, 1 for Track Details
//api for items
  Future<List<dynamic>?>? itemsdata;

  Future<List<dynamic>?>? itemdata() async {
    Uri trackurl = Uri.parse(UrlRescource.ALLITEM);

    print("uri = ${trackurl}");
    var responce = await http.get(trackurl);
    print("responce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("body = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }

  //api for track
  Future<List<dynamic>?>? tracksdata;
  Future<List<dynamic>?>? trackdata() async {
    Uri trackurl = Uri.parse(UrlRescource.ALLTRACK);

    print("trackurl = ${trackurl}");
    var responce = await http.get(trackurl);
    print("trackresponce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("trackbody = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      itemsdata = itemdata();
      tracksdata = trackdata();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1976d2), Color(0xffff8f00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 25),
                  Text(
                    "View Orders ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Tabs
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      height: 60,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedTab = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: selectedTab == 0
                                  ? [Color(0xff64b5f6), Color(0xff2962ff)]
                                  : [Colors.grey.shade300, Colors.grey.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Items Details",
                              style: TextStyle(
                                fontSize: 18,
                                color: selectedTab == 0 ? Colors.white : Colors.black,
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
                          setState(() {
                            selectedTab = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: selectedTab == 1
                                  ? [Color(0xff81c784), Color(0xff388e3c)]
                                  : [Colors.grey.shade300, Colors.grey.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Track Details",
                              style: TextStyle(
                                fontSize: 18,
                                color: selectedTab == 1 ? Colors.white : Colors.black,
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
            ),

            // Dynamic Content
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: selectedTab == 0
                    ? _buildItemsDetails()
                    : _buildTrackDetails(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemsDetails() {
    return FutureBuilder<List<dynamic>?>(
      future: itemsdata,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available"));
        } else {
          final data = snapshot.data!;
          // You can map this list into a list of widgets
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(Icons.local_hospital, "Order ID", item["order_id"]?.toString() ?? "N/A"),
                    _buildSection(Icons.info, "Product ID", item["product_id"]?.toString() ?? "N/A"),
                    _buildSection(Icons.medical_services, "Quantity", item["quantity"]?.toString() ?? "N/A"),
                    _buildSection(Icons.location_on, "Price", item["price"]?.toString() ?? "N/A"),
                    Divider(thickness: 2),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }



  Widget _buildTrackDetails() {
    return FutureBuilder<List<dynamic>?>(
      future: tracksdata,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No tracking data available"));
        } else {
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(Icons.local_hospital, "Order Name", item["order_id"]?.toString()),
                    _buildSection(Icons.info, "Status", item["status"]?.toString()),
                    _buildSection(Icons.medical_services, "Description", item["track_description"]?.toString()),
                    _buildSection(Icons.location_on, "Datetime", item["track_datetime"]?.toString()),
                    const Divider(thickness: 2),
                  ],
                ),
              );
            },
          );
        }
      },
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



