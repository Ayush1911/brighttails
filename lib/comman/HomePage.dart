import 'dart:convert';

import 'package:brighttails/animal/AnimalDetails.dart';
import 'package:brighttails/animal/AnimalPage.dart';
import 'package:brighttails/article/ArticleDetails.dart';
import 'package:brighttails/article/ArticlePage.dart';
import 'package:brighttails/auth/LoginPage.dart';
import 'package:brighttails/brand/BrandProduct.dart';
import 'package:brighttails/brand/brandPage.dart';
import 'package:brighttails/breed/Breed.dart';
import 'package:brighttails/cart/CartPage.dart';
import 'package:brighttails/category/Category.dart';
import 'package:brighttails/category/SubCategory.dart';
import 'package:brighttails/comman/ChangePassword.dart';
import 'package:brighttails/comman/ThankYou.dart';
import 'package:brighttails/coupon/CouponPage.dart';
import 'package:brighttails/doctor/DoctorPage.dart';
import 'package:brighttails/faq/FaqPage.dart';
import 'package:brighttails/hospital/HospitalPage.dart';
import 'package:brighttails/order/Orders.dart';
import 'package:brighttails/pet/PetDetails.dart';
import 'package:brighttails/pet/PetPage.dart';
import 'package:brighttails/profile/MyProfileView.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:brighttails/shop/ProductsPage.dart';
import 'package:brighttails/wishlist/Wishlist.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>?>? alldata;

  var img = UrlRescource.CATEGORYIMG;
  var img1 = UrlRescource.USERIMG;

  Future<List<dynamic>?>? getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLCATEGORY);

    print("uri = ${url}");
    var responce = await http.get(url);
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

  Future<List<dynamic>?>? fetchdata;

  var petimg = UrlRescource.PETIMG;

  Future<List<dynamic>?>? petdata() async {
    Uri peturl = Uri.parse(UrlRescource.ALLPET);

    print("uri = ${peturl}");
    var responce = await http.get(peturl);
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

  Future<List<dynamic>?>? animalsdata;

  var animalimg = UrlRescource.ANIMALIMG;

  Future<List<dynamic>?>? animaldata() async {
    Uri animalurl = Uri.parse(UrlRescource.ALLANIMAL);

    print("uri = ${animalurl}");
    var responce = await http.get(animalurl);
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
//api for articles
  Future<List<dynamic>?>? articlesdata;

  var articleimg = UrlRescource.ARTICLEIMG;

  Future<List<dynamic>?>? articledata() async {
    Uri articleurl = Uri.parse(UrlRescource.ALLARTICLE);

    print("uri = ${articleurl}");
    var responce = await http.get(articleurl);
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

  //api for brand
  Future<List<dynamic>?>? brandsdata;

  var barndimg = UrlRescource.BRANDIMG;

  Future<List<dynamic>?>? branddata() async {
    Uri brandurl = Uri.parse(UrlRescource.ALLBRAND);

    print("brandurl = ${brandurl}");
    var responce = await http.get(brandurl);
    print("brandresponce = ${responce.statusCode}");

    if (responce.statusCode == 200) {
      var body = responce.body.toString();
      print("brandbody = ${body}");
      var json = jsonDecode(body);
      // print("json = ${json["data"]}");

      return json["data"];
    } else {
      print("Api Error!");
    }
  }
  var uname = "";
  // var uname = "";
  var email = "";
  var userimage = "";

  getuserdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      email = prefs.getString("useremail") ?? "";
      uname = prefs.getString("username") ?? "";
      userimage = prefs.getString("userimage") ?? "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    setState(() {
      alldata = getdata();
      fetchdata = petdata();
      animalsdata = animaldata();
      articlesdata = articledata();
      brandsdata = branddata();
    });

  }

  TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final List<String> imageList = [
  //   'assets/image/img1.jpeg',
  //   'assets/image/img2.jpeg',
  //   'assets/image/img3.jpeg',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          // Ensures content is within safe screen boundaries
          child: Container(
            color: Color(0xffe0f7fa), // Background color for the drawer
            child: ListView(
              padding: EdgeInsets.zero, // Remove default padding
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff1976d2), Color(0xffff8f00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      // Navigate to the HomePage when the icon is tapped
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyProfileView()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white, // Optional: Add a background color
                      child: ClipOval(
                        child: Image.network(
                          UrlRescource.USERIMG + userimage,
                          // width: 50, // Adjust the width as needed
                          // height: 50, // Adjust the height as needed
                          fit: BoxFit.cover, // Ensures the image covers the entire space
                        ),
                      ),
                    ),
                  ),
                  accountName: Text(
                    uname.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: 18, // Adjust size if needed
                      color: Colors.white, // Optional: Change text color
                    ),
                  ),
                  accountEmail: Text(
                    email.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: 16, // Adjust size if needed
                      color: Colors.white, // Optional: Change text color
                    ),
                  ),

                ),


                //start home
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  leading: Icon(Icons.home, color: Colors.blue),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                //start hospital
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HospitalPage()),
                    );
                  },
                  leading: Icon(Icons.local_hospital, color: Colors.blue),
                  // Hospital icon
                  title: Text(
                    "Hospital",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start shop
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Category()),
                    );
                  },
                  leading: Icon(Icons.shopping_cart, color: Colors.blue),
                  title: Text(
                    "Shop",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start brand
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Brandpage()),
                    );
                  },
                  leading: Icon(Icons.branding_watermark, color: Colors.blue),
                  title: Text(
                    "Brand",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start Coupon
                SizedBox(height: 5),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => CouponPage()),
                    );
                  },
                  leading: Icon(Icons.card_giftcard, color: Colors.blue),
                  // Coupon
                  title: Text(
                    "Coupon",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start Doctor
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => DoctorPage()),
                    );
                  },
                  leading: Icon(Icons.medical_services, color: Colors.blue),
                  // Doctors
                  title: Text(
                    "Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start pet
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AnimalPage()),
                    );
                  },
                  leading: Icon(Icons.pets, color: Colors.blue), // Pets
                  title: Text(
                    "Animal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start articles
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Articlepage()),
                    );
                  },
                  leading: Icon(Icons.article, color: Colors.blue), // Articles
                  title: Text(
                    "Article",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start faq
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Faqpage()),
                    );
                  },
                  leading: Icon(Icons.help_outline, color: Colors.blue), // FAQ
                  title: Text(
                    "FAQ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start my order
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Orders()),
                    );
                  },
                  leading: Icon(Icons.shopping_bag, color: Colors.blue),
                  // My Order
                  title: Text(
                    "My Order",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start wishlist
                SizedBox(height: 5), // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Wishlist()),
                    );
                  },
                  leading: Icon(Icons.bookmark, color: Colors.blue),
                  // My Order
                  title: Text(
                    "Wishlist",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start change password
                 // Space between Home and Hospital
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                  leading: Icon(Icons.password, color: Colors.blue),
                  // My Order
                  title: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
                //start logout
                ListTile(
                  onTap: () {
                    _showLogoutDialog();
                  },
                  leading: Icon(Icons.logout, color: Colors.blue), // Logout
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Different color for distinction
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // appBar: AppBar(),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            icon: Icon(Icons.menu,
                              color: Colors.white,
                              size: 40,
                            )),
                        Text(
                          "BrightTails",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => CartPage(imgurl: img)),
                            );
                          },
                          style: IconButton.styleFrom(
                            // backgroundColor: Colors.white,
                          ),
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 10,
                color: Colors.black12,
                height: 340,
              ),
              Positioned(
                top: 110,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - 110,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      // height: 650,
                      width: MediaQuery.of(context).size.width,
                      // color: Color(0xffe0f7fa),
                      color: Color(0xffffffff),

                      child: Container(
                        padding: new EdgeInsets.only(bottom: 10),
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            CarouselSlider(
                              items: [
                                //1st Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/image/image_1.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //2nd Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/image/image_2.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                //3rd Image of Slider
                                Container(
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/image/image_3.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],

                              //Slider Container properties
                              options: CarouselOptions(
                                height: 250,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                viewportFraction: 1.1,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Align items to edges
                                        children: [
                                          Text(
                                            "Shop By Category",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                         Category()));
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration
                                                    .underline, // Underline the text
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Space between title and row
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // Enables horizontal scrolling
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Color(0xffffffff),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: alldata,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text("No Category Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                          snapshot.data!.length,
                                                          (index) {
                                                        var category = snapshot
                                                            .data![index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                       SubCategory(GetData: category["category_id"],)));
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            // Ensure 2 cards fit per screen width
                                                            margin: EdgeInsets.all(1),
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                  // borderRadius: BorderRadius.circular(100), // Circular shape
                                                                  ),
                                                              color: Color(
                                                                  0xfffafafa),
                                                              margin: EdgeInsets
                                                                  .all(1),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ClipRRect(
                                                                    // borderRadius: BorderRadius.circular(50), // Rounded image
                                                                    child: Image
                                                                        .network(
                                                                      img +
                                                                          category["category_image"]
                                                                              .toString(),
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          " ${category["category_name"]}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),


                            //shop by animal
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Align items to edges
                                        children: [
                                          Text(
                                            "Shop By Animal",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 90,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AnimalPage()));
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration
                                                    .underline, // Underline the text
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Space between title and row
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // Enables horizontal scrolling
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Color(0xffffffff),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: animalsdata,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          "No Animal Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                          snapshot.data!.length,
                                                          (index) {
                                                        var animal = snapshot
                                                            .data![index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Breed(GetData: animal["animal_id"],)));
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            // Ensure 2 cards fit per screen width
                                                            margin: EdgeInsets.all(1),
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                  // borderRadius: BorderRadius.circular(100), // Circular shape
                                                                  ),
                                                              color: Color(
                                                                  0xfffafafa),
                                                              margin: EdgeInsets
                                                                  .all(1),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ClipRRect(
                                                                    // borderRadius: BorderRadius.circular(50), // Rounded image
                                                                    child: Image
                                                                        .network(
                                                                      animalimg +
                                                                          animal["animal_image"]
                                                                              .toString(),
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      // fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "  ${animal["animal_name"]}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //start Adopt pet
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Align items to edges
                                        children: [
                                          Text(
                                            "Adopt Pet",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AnimalPage()));
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration
                                                    .underline, // Underline the text
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Space between title and row
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // Enables horizontal scrolling
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Color(0xffffffff),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: fetchdata,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text("No Pets Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                          snapshot.data!.length,
                                                          (index) {
                                                        var pet = snapshot
                                                            .data![index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PetDetails(
                                                                              GetData: pet,
                                                                              imgurl: petimg,
                                                                            )));
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            // Ensure 2 cards fit per screen width
                                                            margin: EdgeInsets.all(1),
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                  // borderRadius: BorderRadius.circular(100), // Circular shape
                                                                  ),
                                                              color: Color(
                                                                  0xfffafafa),
                                                              margin: EdgeInsets
                                                                  .all(1),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ClipRRect(
                                                                    // borderRadius: BorderRadius.circular(50), // Rounded image
                                                                    child: Image
                                                                        .network(
                                                                      petimg +
                                                                          pet["pet_image_1"]
                                                                              .toString(),
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          150,
                                                                      // fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "  ${pet["pet_name"]}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // start brand
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        // Align items to edges
                                        children: [
                                          Text(
                                            "Lists Of Brands",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Brandpage()));
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration
                                                    .underline, // Underline the text
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Space between title and row
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // Enables horizontal scrolling
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Color(0xffffffff),
                                            padding:
                                            EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: brandsdata,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                      CircularProgressIndicator());
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text("No Brand Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                          snapshot.data!.length,
                                                              (index) {
                                                            var brand = snapshot
                                                                .data![index];
                                                            return InkWell(
                                                              onTap: () {
                                                                Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Brandproduct(GetData: brand["brand_id"],)));
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .width /
                                                                    2,
                                                                // Ensure 2 cards fit per screen width
                                                                margin: EdgeInsets.all(1),
                                                                child: Card(
                                                                  shape: RoundedRectangleBorder(
                                                                    // borderRadius: BorderRadius.circular(100), // Circular shape
                                                                  ),
                                                                  color: Color(
                                                                      0xfffafafa),
                                                                  margin: EdgeInsets
                                                                      .all(1),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      ClipRRect(
                                                                        // borderRadius: BorderRadius.circular(50), // Rounded image
                                                                        child: Image
                                                                            .network(
                                                                          barndimg +
                                                                              brand["brand_logo"]
                                                                                  .toString(),
                                                                          height:
                                                                          150,
                                                                          width:
                                                                          150,
                                                                          // fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                          10),
                                                                      Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                        child:
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Text(
                                                                              "  ${brand["brand_name"]}",
                                                                              style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                16,
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                color:
                                                                                Colors.black,
                                                                              ),
                                                                              textAlign:
                                                                              TextAlign.center,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //start articles
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Align items to edges
                                        children: [
                                          Text(
                                            "Latest Articles",
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Articlepage()));
                                            },
                                            child: Text(
                                              "View All",
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.blue,
                                                decoration: TextDecoration
                                                    .underline, // Underline the text
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Space between title and row
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // Enables horizontal scrolling
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Color(0xffffffff),
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: FutureBuilder(
                                              future: articlesdata,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data!.isEmpty) {
                                                  return Center(
                                                      child: Text(
                                                          "No Articles Data"));
                                                } else {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                          snapshot.data!.length,
                                                          (index) {
                                                        var article = snapshot
                                                            .data![index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Articledetails(
                                                                              GetData: article,
                                                                              imgurl: articleimg,
                                                                            )));
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1,
                                                            // Ensure 2 cards fit per screen width
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        1),
                                                            child: Card(
                                                              shape: RoundedRectangleBorder(
                                                                  // borderRadius: BorderRadius.circular(100), // Circular shape
                                                                  ),
                                                              color: Color(
                                                                  0xfffafafa),
                                                              margin: EdgeInsets
                                                                  .all(1),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ClipRRect(
                                                                    // borderRadius: BorderRadius.circular(50), // Rounded image
                                                                    child: Image
                                                                        .network(
                                                                      articleimg +
                                                                          article["article_image_1"]
                                                                              .toString(),
                                                                      height:
                                                                          150,
                                                                      width:
                                                                          2000,
                                                                      // fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "  ${article["title"]}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: ()async {
                // Perform Logout

                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Loginpage()),
                );
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
}
