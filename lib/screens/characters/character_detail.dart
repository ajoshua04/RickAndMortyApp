import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/models/location_model.dart';

import '../../models/character_model.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    character.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('Status: ', character.status,
                valueStyle: _getStatusTextStyle(character.status)),
            SizedBox(height: 10),
            _buildDetailRow('Species: ', character.species),
            if (character.type != '') ...[
              SizedBox(height: 10),
              _buildDetailRow('Type: ', character.type),
            ],
            SizedBox(height: 10),
            _buildDetailRow('Gender: ', character.gender),
            SizedBox(height: 10),
            _buildDetailRow('Origin: ', character.origin),
            
          ],
        ),
      ),
    );
  }

  TextStyle _getStatusTextStyle(String status) {
    Color textColor;
    if (status == 'Dead') {
      textColor = Colors.red;
    } else if (status == 'Alive') {
      textColor = Colors.blue;
    } else {
      // For unknown status
      textColor = Colors.green;
    }

    return TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold);
  }

  Widget _buildDetailRow(String title, String value, {TextStyle? valueStyle}) {
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
            style: valueStyle ?? TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
