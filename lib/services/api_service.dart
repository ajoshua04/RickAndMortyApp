// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/character_model.dart';
import '../models/episode_model.dart';
import '../models/location_model.dart';


class ApiService {
  static const baseUrl = 'https://rickandmortyapi.com/api';

  Future<List<Character>> fetchAllCharacters() async {
    try {
      List<Character> allCharacters = [];
      int currentPage = 1;

      while (true) {
        final response = await http.get(Uri.parse('$baseUrl/character/?page=$currentPage'));
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          if (jsonData['results'] != null) {
            List<Character> characters = (jsonData['results'] as List)
                .map((characterJson) => Character.fromJson(characterJson))
                .toList();
            allCharacters.addAll(characters);
            currentPage++;

            if (jsonData['info'] != null && jsonData['info']['next'] == null) {
              // Reached the last page, break the loop
              break;
            }
          } else {
            throw Exception('Error fetching characters: Results data is null.');
          }
        } else {
          throw Exception('Error fetching characters: ${response.statusCode}');
        }
      }

      return allCharacters;
    } catch (e) {
      throw Exception('Error fetching characters: $e');
    }
  }

  

  Future<List<Location>> fetchAllLocations() async {
  try {
    List<Location> allLocations = [];
    int currentPage = 1;

    while (true) {
      final response = await http.get(Uri.parse('$baseUrl/location/?page=$currentPage'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['results'] != null) {
          List<Location> locations = (jsonData['results'] as List)
              .map((locationJson) => Location.fromJson(locationJson))
              .toList();
          allLocations.addAll(locations);
          currentPage++;

          if (jsonData['info'] != null && jsonData['info']['next'] == null) {
            // Reached the last page, break the loop
            break;
          }
        } else {
          throw Exception('Error fetching locations: Results data is null.');
        }
      } else {
        throw Exception('Error fetching locations: ${response.statusCode}');
      }
    }

    return allLocations;
  } catch (e) {
    throw Exception('Error fetching locations: $e');
  }
}

  Future<List<Episode>> fetchAllEpisodes() async {
  try {
    List<Episode> allEpisodes = [];
    int currentPage = 1;

    while (true) {
      final response = await http.get(Uri.parse('$baseUrl/episode/?page=$currentPage'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['results'] != null) {
          List<Episode> episodes = (jsonData['results'] as List)
              .map((episodeJson) => Episode.fromJson(episodeJson))
              .toList();
          allEpisodes.addAll(episodes);
          currentPage++;

          if (jsonData['info'] != null && jsonData['info']['next'] == null) {
            // Reached the last page, break the loop
            break;
          }
        } else {
          throw Exception('Error fetching episodes: Results data is null.');
        }
      } else {
        throw Exception('Error fetching episodes: ${response.statusCode}');
      }
    }

    return allEpisodes;
  } catch (e) {
    throw Exception('Error fetching episodes: $e');
  }
}
}
