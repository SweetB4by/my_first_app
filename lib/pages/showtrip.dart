import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/trip_get_res.dart';
import 'package:my_first_app/pages/tripdetail.dart';
import 'package:my_first_app/pages/profile.dart';

class ShowTripPage extends StatefulWidget {
  const ShowTripPage({super.key});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  getTrips() async {
    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    setState(() {
      tripGetResponses = tripGetResponseFromJson(res.body);
    });
    log(tripGetResponses.length.toString());
  }

  getZoneAsia() async {
    var res = await http.get(Uri.parse('$url/trips'));
    setState(() {
      var allTrips = tripGetResponseFromJson(res.body);
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == DestinationZone.asia)
          .toList();
    });
  }

  getZoneEurope() async {
    var res = await http.get(Uri.parse('$url/trips'));
    setState(() {
      var allTrips = tripGetResponseFromJson(res.body);
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == DestinationZone.europe)
          .toList();
    });
  }

  getZoneSoutheastAsia() async {
    var res = await http.get(Uri.parse('$url/trips'));
    setState(() {
      var allTrips = tripGetResponseFromJson(res.body);
      tripGetResponses = allTrips
          .where(
            (trip) => trip.destinationZone == DestinationZone.southeastAsia,
          )
          .toList();
    });
  }

  getZoneThailand() async {
    var res = await http.get(Uri.parse('$url/trips'));
    setState(() {
      var allTrips = tripGetResponseFromJson(res.body);
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == DestinationZone.thailand)
          .toList();
    });
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    tripGetResponses = tripGetResponseFromJson(res.body);
    log(tripGetResponses.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'โปรไฟล์',
            onPressed: () {
              // กดแล้วไปหน้า ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(idx: 1), // ใส่ค่า idx ของ user
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // ปุ่ม filter
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () => getTrips(),
                    child: const Text('ทั้งหมด'),
                  ),
                  const SizedBox(width: 5),
                  FilledButton(
                    onPressed: () => getZoneAsia(),
                    child: const Text('เอเชีย'),
                  ),
                  const SizedBox(width: 5),
                  FilledButton(
                    onPressed: () => getZoneEurope(),
                    child: const Text('ยุโรป'),
                  ),
                  const SizedBox(width: 5),
                  FilledButton(
                    onPressed: () => getZoneSoutheastAsia(),
                    child: const Text('เอเชียตะวันออกเฉียงใต้'),
                  ),
                  const SizedBox(width: 5),
                  FilledButton(
                    onPressed: () => getZoneThailand(),
                    child: const Text('ประเทศไทย'),
                  ),
                ],
              ),
            ),
          ),
          // ListView แสดง Card จาก API
          Expanded(
            child: ListView.builder(
              itemCount: tripGetResponses.length,
              itemBuilder: (context, index) {
                final trip = tripGetResponses[index];
                return Card(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // ถ้า API มี url รูป ใช้ Image.network
                            // ถ้าใช้ asset แบบเดิมก็เปลี่ยนเป็น Image.asset
                            Image.network(
                              trip.coverimage,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 120,
                                    width: 120,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                    ),
                                  ),
                            ),

                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ประเทศ : ${trip.country}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "ระยะเวลา : ${trip.duration}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "ราคา : ${trip.price}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 15),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              tripdetail(trip: trip),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'รายละเอียดเพิ่มเติม',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
