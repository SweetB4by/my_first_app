import 'package:flutter/material.dart';
import 'package:my_first_app/model/response/trip_get_res.dart';

class tripdetail extends StatelessWidget {
  final TripGetResponse trip;

  const tripdetail({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trip.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              trip.coverimage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              trip.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "ประเทศ: ${trip.country}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "ระยะเวลา: ${trip.duration} วัน",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "ราคา: ${trip.price} บาท",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "โซน: ${destinationZoneValues.reverse[trip.destinationZone]}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(trip.detail, style: const TextStyle(fontSize: 14)),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('จองเลย'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
