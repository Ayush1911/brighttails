import 'dart:convert';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/order/OrdersView.dart';

import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future<List<dynamic>?>? alldata;
  var img = UrlRescource.PRODUCTIMG;

  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  Future<List<dynamic>?> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui = prefs.getString("userid") ?? "";

    if (ui.isEmpty) {
      return [];
    }

    Uri url = Uri.parse(UrlRescource.ALLMYORDER);
    try {
      var response = await http.post(url, body: {"user_id": ui});
      var jsonData = jsonDecode(response.body);
      return jsonData["data"] is List ? jsonData["data"] : [];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 25),
                  Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      // spreadRadius: 3,
                      // blurRadius: 5,
                      // offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: FutureBuilder<List<dynamic>?>(
                  future: alldata,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var order = snapshot.data![index];
                          String imageUrl = order["image_1"]?.toString().isNotEmpty == true
                              ? "$img${order["image_1"]}"
                              : "";

                          return InkWell(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Ordersview()), // Replace with your actual page
                              );
                            },
                            borderRadius: BorderRadius.circular(12), // match card shape
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 15),
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                                        child: imageUrl.isNotEmpty
                                            ? null
                                            : Icon(Icons.person, color: Colors.white, size: 30),
                                      ),
                                      title: Text(
                                        "Transaction No: ${order["transaction_number"] ?? "N/A"}",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "Amount: ₹${order["amount"]?.toString() ?? "0.00"}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Status: ${order["status"] ?? "Unknown"}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: (order["payment"] == "Completed")
                                                ? Colors.green
                                                : Colors.blue,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            order["payment"] ?? "Pending",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                        },
                      );
                    } else {
                      return Center(child: Text("No Orders Available"));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}