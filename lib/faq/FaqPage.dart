import 'dart:convert';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1976d2), Color(0xffff8f00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Faqpage extends StatefulWidget {
  const Faqpage({super.key});

  @override
  State<Faqpage> createState() => _FaqpageState();
}

class _FaqpageState extends State<Faqpage> {
  late Future<List<dynamic>?> alldata;

  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLFAQ);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return jsonData["data"];
      } else {
        debugPrint("API Error: \${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching data: \$e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    alldata = getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(

          children: [
            HeaderWidget(title: "FAQ Lists", onBack: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()))),
            SizedBox(height: 50,),
            Expanded(
              child: FutureBuilder<List<dynamic>?> (
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(

                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var faq = snapshot.data![index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          elevation: 4,

                          child: ExpansionTile(
                            title: Text(
                              faq["question"],
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  faq["answer"],
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No FAQs available", style: TextStyle(fontSize: 18)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
