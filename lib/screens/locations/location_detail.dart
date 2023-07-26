import 'package:flutter/material.dart';
import '../../models/location_model.dart'; // Import the Location model

class LocationDetailScreen extends StatelessWidget {
  final Location location;

  LocationDetailScreen({required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(location.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            _buildDetailRow('Name: ', location.name),
            SizedBox(height: 10),
            _buildDetailRow('Type: ', location.type),
            SizedBox(height: 10),
            _buildDetailRow('Dimension: ', location.dimension),
            
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
