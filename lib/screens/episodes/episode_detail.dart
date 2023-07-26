import 'package:flutter/material.dart';

import '../../models/episode_model.dart';

class EpisodeDetailScreen extends StatelessWidget {
  final Episode episode;

  EpisodeDetailScreen({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(episode.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            _buildDetailRow('Name: ', episode.name),
            SizedBox(height: 10),
            _buildDetailRow('Air Date: ', episode.airDate),
            SizedBox(height: 10),
            _buildDetailRow('Episode: ', episode.episode),
            
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