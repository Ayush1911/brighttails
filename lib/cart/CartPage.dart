import 'dart:convert';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:brighttails/shop/CheckOut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required imgurl});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<dynamic>?>? alldata;
  var img = UrlRescource.PRODUCTIMG;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  Future<List<dynamic>?> getdata() async {
    finaltotal = 0;
    Uri url = Uri.parse(UrlRescource.ALLCART);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var data = json["data"];

      // Calculate total only once here
      if (data != null && data.isNotEmpty) {
        for (var cartItem in data) {
          var price = int.parse(cartItem["price"].toString());
         setState(() {
           finaltotal += price;
         });
        }
        print("Final Total: $finaltotal");
      }

      return data;
    } else {
      print("Api Error!");
    }
  }
  int finaltotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff1976d2), Color(0xffff8f00),Color(0xffff8f00), Color(0xff1976d2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            style: IconButton.styleFrom(
                                // backgroundColor: Colors.white,
                                ),
                            icon: Icon(
                              Icons.arrow_back,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Cart Lists",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  bottom: 70,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight - 160,
                    ),
                    child: Container(
                      color: Color(0xFFFFFFFF),
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder(
                        future: alldata,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                                strokeWidth: 4,
                              ),
                            );
                          }
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var cartItem = snapshot.data![index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 5,
                                          color: Color(0xFFF3F4F6),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // Rounded image
                                                  child: Image.network(
                                                    img +
                                                        cartItem["image_1"]
                                                            .toString(),
                                                    height: 120,
                                                    width: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.person,
                                                                color: Colors
                                                                    .blueAccent),
                                                            SizedBox(width: 5),
                                                            Flexible(
                                                              child: Text(
                                                                "User: ${cartItem["name"]}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .shopping_bag,
                                                                color: Colors
                                                                    .orangeAccent),
                                                            SizedBox(width: 5),
                                                            Flexible(
                                                              child: Text(
                                                                "Product: ${cartItem["title"]}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .format_list_numbered,
                                                                color: Colors
                                                                    .teal),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              "Qty: ${cartItem["quantity"]}",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .currency_rupee,
                                                                color: Colors
                                                                    .green),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              "Price: \ ₹ ${cartItem["price"]}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    bool? confirmed =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Row(
                                                            children: [
                                                              Icon(Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  "Delete Item"),
                                                            ],
                                                          ),
                                                          content: Text(
                                                              "Are you sure you want to remove this item from your cart?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      false),
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      true),
                                                              child: Text(
                                                                  "Delete"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    if (confirmed == true) {
                                                      Uri url = Uri.parse(
                                                          UrlRescource
                                                              .DELETECART);
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      var ci = prefs
                                                          .getString("cartid")
                                                          .toString();
                                                      var parms = {
                                                        "cart_id":
                                                            cartItem["cart_id"]
                                                                .toString()
                                                      };
                                                      var response =
                                                          await http.post(url,
                                                              body: parms);

                                                      if (response.statusCode ==
                                                          200) {
                                                        var json = jsonDecode(
                                                            response.body
                                                                .toString());
                                                        if (json["status"] ==
                                                            "true") {
                                                          var msg =
                                                              json["messages"]
                                                                  .toString();
                                                          print(msg);
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CartPage(
                                                                        imgurl:
                                                                            img)),
                                                          );
                                                        } else {
                                                          print(
                                                              "Error: ${json["messages"]}");
                                                        }
                                                      } else {
                                                        print("API Error!");
                                                      }
                                                    }
                                                  },
                                                  style: IconButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                  icon: Icon(
                                                      Icons.delete_forever,
                                                      size: 28,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                "No items in the cart",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total: ${finaltotal}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CheckOut(total: finaltotal,)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
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
                              "Checkout",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
