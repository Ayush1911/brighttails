import 'dart:convert';
import 'package:brighttails/comman/HomePage.dart';
import 'package:brighttails/hospital/HospitalDetails.dart';
import 'package:brighttails/resources/UrlRescource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchText = '';
  Future<List<dynamic>?>? alldata;
  final TextEditingController _searchController = TextEditingController();
  final String img = UrlRescource.HOSPITALIMG;

  List<dynamic>? _allEvents;
  List<dynamic>? _filteredEvents;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    // Kick off loading data
    alldata = getdata();

    // Listen to text changes
    _searchController.addListener(() {
      filterEvents(_searchController.text);
    });
  }

  Future<List<dynamic>?> getdata() async {
    Uri url = Uri.parse(UrlRescource.ALLHOSPITAL);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      _allEvents = jsonBody["data"];
      _filteredEvents = _allEvents;
      return _filteredEvents;
    } else {
      print("API Error!");
      return [];
    }
  }

  void filterEvents(String query) {
    final filtered = _allEvents
        ?.where((event) =>
        event["hospital_name"]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
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
      backgroundColor: Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: FutureBuilder<List<dynamic>?>(
                future: alldata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Hospitals Found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  final list = _filteredEvents!;
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final hospital = list[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HospitalDetails(
                                GetData: hospital,
                                imgurl: img,
                              ),
                            ),
                          );
                        },
                        child: _buildHospitalCard(hospital),
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
        gradient: LinearGradient(
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
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => HomePage())),
                icon: Icon(Icons.arrow_back,
                    size: 30, color: Colors.white),
              ),
              SizedBox(width: 15),
              Text(
                "Hospitals List",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
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
                hintText: "Search hospitals...",
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

  Widget _buildHospitalCard(Map<String, dynamic> hospital) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        children: [
          Container(
            width: 130,
            padding: EdgeInsets.all(5),
            child: Image.network(
              img + (hospital["logo"] ?? ""),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              hospital["hospital_name"] ?? "",
              style: TextStyle(
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
    );
  }
}
