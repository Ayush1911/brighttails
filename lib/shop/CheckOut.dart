import 'dart:convert';

import 'package:brighttails/comman/ThankYou.dart';
import 'package:brighttails/shop/ProductsDetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../resources/UrlRescource.dart';

class CheckOut extends StatefulWidget {



  var total;

   CheckOut({super.key,this.total});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  var formkey = GlobalKey<FormState>();
  Razorpay _razorpay = Razorpay();
  TextEditingController userid = TextEditingController();
  TextEditingController addressline1 = TextEditingController();
  TextEditingController addressline2 = TextEditingController();
  TextEditingController inqdatetime = TextEditingController();
  TextEditingController pincode = TextEditingController();

  List<dynamic> cityData = [];
  var city;

  Future<List<dynamic>?>? allcitydata;
  Future<List<dynamic>?>? getcitydata()async{
    Uri uri = Uri.parse(UrlRescource.ALLCITYDATA);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        cityData = body['data'];
      });
    } else {
      print("api error");
    }
  }


  List<dynamic> couponData = [];
  var coupon;
  Future<List<dynamic>?>? allcoupondata;
  Future<List<dynamic>?>? getcoupondata()async{
    Uri uri = Uri.parse(UrlRescource.ALLCOUPONDATA);
    var responce = await http.get(uri);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      setState(() {
        couponData = body['data'];
      });
    } else {
      print("api error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      allcitydata =  getcitydata();
      allcoupondata =  getcoupondata();

    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


  }

  var deliverycharges = "0";

  void _handlePaymentSuccess(PaymentSuccessResponse paymentresponse) async{
    // Do something when payment succeeds

    // var pi = status.text.toString();
    var add1 = addressline1.text.toString();
    var add2 = addressline2.text.toString();
    var pin = pincode.text.toString();


    // 200 ok
    //400 no found
    //500 sever

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ui =  prefs.getString("userid").toString();

    print("userid = ${ui}");
    print("coupon_id = ${coupon}");
    print("city = ${city}");
    print("add1 = ${add1}");
    print("add2 = ${add2}");
    print("pin = ${pin}");
    print("widget.total = ${widget.total}");
    print("discount = ${discountedTotal.toString()}");
    print("amt = ${amt}");
    print("deliverycharges = ${deliverycharges.toString()}");
    print("tranid = ${paymentresponse.paymentId.toString()}");



    var parms = {
      // "pet_id ":pet.toString(),
      "city_id":city.toString(),
      "coupon_id":coupon.toString(),
      "address_line1":add1.toString(),
      "address_line2":add2.toString(),
      "pincode":pin.toString(),
      "amount":discountedTotal.toString(),
      "status":"Pending",
      "transaction_number":paymentresponse.paymentId.toString(),
      // "payment":discountedTotal.toString(),
      "discount":amt.toString(),
      "delivery_charges":deliverycharges.toString(),
      "user_id":ui.toString()

    };

    print("parms = ${parms}");
    Uri url = Uri.parse(UrlRescource.ADDCHECKOUT);

    print("uri = ${url}");
    var responce = await http.post(url,body: parms);
    print("responce = ${responce.statusCode}");

    if(responce.statusCode==200)
    {
      // var body = responce.body.toString();
      // print("body = ${body}");
      var json = jsonDecode(responce.body.toString());
      print("json = ${json}");

      if(json["status"]=="true")
      {
        var msg = json["messages"].toString();
        print(msg);
        Fluttertoast.showToast(
            msg: "Payment Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ThankYou()),
        );
      }
      else
      {
        var msg = json["messages"].toString();
        print(msg);
      }
    }
    else
    {
      print("Api Error!");
    }


  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

    print("PaymentError");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("WalletError");

  }
  var amt=0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  int discount = 0;
  int discountedTotal = 0;

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
                      Navigator.of(context).pop(
                          MaterialPageRoute(builder: (context) => ProductsDetails())
                      );
                    },
                    style: IconButton.styleFrom(

                    ),
                    icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Checkout",
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select City:",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              cityData.isNotEmpty
                                  ? DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  prefixIcon: Icon(Icons.location_city, color: Colors.blue),
                                  hintText: "Select your City",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                value: city != null && city.toString().isNotEmpty ? city : null,
                                items: cityData.map((value) {
                                  deliverycharges = value["delivery_charge"];
                                  return DropdownMenuItem<String>(
                                    value: value['city_id'],
                                    child: Text(value['city_name']),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    city = val!;
                                    print(city);
                                  });
                                },
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Select Coupon:", style: TextStyle(fontSize: 18)),
                              SizedBox(height: 5),
                              couponData.isNotEmpty
                                  ? DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  prefixIcon: Icon(Icons.card_giftcard, color: Colors.blue),
                                  hintText: "Select your coupon",
                                ),
                                value: coupon != null && coupon.toString().isNotEmpty ? coupon : null,
                                // Filter couponData based on the total amount
                                items: couponData
                                    .where((item) {
                                  int minAmount = int.parse(item['minimum_amount'].toString());
                                  int maxAmount = int.parse(item['maximum_amount'].toString());
                                  // Only include coupons that match the total amount range
                                  return widget.total >= minAmount && widget.total <= maxAmount;
                                })
                                    .map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value['coupon_id'],
                                    child: Text(value['coupon_code']),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    coupon = val!;

                                    var selectedCoupon = couponData.firstWhere((item) => item['coupon_id'] == val);

                                    // Get the discount percentage from the selected coupon
                                    discount = int.parse(selectedCoupon['discount'].toString());

                                    amt = (widget.total * discount) ~/ 100;
                                    print("amt = ${amt}");
                                    // Calculate the discounted total
                                    discountedTotal = widget.total - (amt);
                                    print("Discounted Total: $discountedTotal");
                                  });
                                },
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        buildTextField("Address 1:", addressline1, TextInputType.text, Icons.edit_location_alt, validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter Address 1";
                          }
                          return null;
                        }),
                        SizedBox(height: 25),
                        buildTextField("Land Mark:", addressline2, TextInputType.text, Icons.temple_hindu, validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter Landmark ";
                          }
                          return null;
                        }),
                        SizedBox(height: 25),
                        buildTextField("Pincode:", pincode, TextInputType.number, Icons.info, validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter a pincode";
                          }
                          return null;
                        }),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var email = prefs.getString("useremail");
                              var mobile = prefs.getString("usermobile");
                              var famt = discountedTotal * 100;
                              print("famt =${famt}");
                              var options = {
                                'key': 'rzp_test_EKsJXH84MtJBG2',//key razorpay
                                'amount': famt.toString(),
                                'name': 'Acme Corp.',
                                'description': 'Fine T-Shirt',
                                'prefill': {
                                  'contact': email.toString(),
                                  'email': mobile.toString()
                                }
                              };
                              _razorpay.open(options);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [Color(0xff64b5f6), Color(0xff2962ff)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Text(
                              "Payment : \ ₹ ${discountedTotal > 0 ? discountedTotal : widget.total}",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget buildTextField(String label, TextEditingController controller, TextInputType type, IconData icon, {bool obscure = false, FormFieldValidator<String>? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18)),
        TextFormField(
          controller: controller,
          keyboardType: type,
          // maxLines: ,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: "Enter Your $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
            prefixIcon: Icon(icon, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

