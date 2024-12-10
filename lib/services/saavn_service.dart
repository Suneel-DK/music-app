import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song_model.dart';

class SaavnService {
  static const String baseUrl = 'https://saavn.dev/api';
  
  Future<List<Song>> searchSongs(String query, {int page = 0, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/songs?query=$query&page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> results = data['data']['results'];
          return results.map((json) => Song.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to search songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching songs: $e');
    }
  }

  Future<Song?> getSongDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/songs?id=$id'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Song.fromJson(data['data'][0]);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error getting song details: $e');
    }
  }
}