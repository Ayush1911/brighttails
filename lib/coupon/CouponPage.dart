import 'dart:convert';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CouponPage extends StatefulWidget {
  const CouponPage({super.key});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  Future<List<dynamic>?>? alldata;

  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  Future<List<dynamic>?> getdata() async {
    try {
      Uri url = Uri.parse(UrlRescource.ALLCOUPON);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return json["data"] ?? [];
      } else {
        print("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1976d2), Color(0xffff8f00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Coupons List",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FutureBuilder<List<dynamic>?>(
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No Coupons Available"));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var coupon = snapshot.data![index];
                      String? isActive = coupon["is_active"]?.toString(); // Ensure it's a string

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          leading: Icon(
                            Icons.card_giftcard,
                            size: 50,
                            color: Colors.blue // Corrected logic
                          ),
                          title: Text(
                            coupon["coupon_code"] ?? "N/A",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.attach_money, size: 18, color: Colors.blue),
                                  SizedBox(width: 5),
                                  Text(
                                    "Min: ${coupon["minimum_amount"] ?? "0"} | Max: ${coupon["maximum_amount"] ?? "0"}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.percent, size: 18, color: Colors.green),
                                  SizedBox(width: 5),
                                  Text(
                                    "Discount: ${coupon["discount"] ?? "0"}%",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.verified, size: 18,color: Colors.orange,),
                                  SizedBox(width: 5),
                                  Text(
                                    isActive !, // Corrected logic
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
}
