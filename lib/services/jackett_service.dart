import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JackettService {
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jackett_api_key');
  }

  Future<String?> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jackett_base_url');
  }

  Future<Map<String, dynamic>> search(String query, {int? year}) async {
    final apiKey = await getApiKey();
    final baseUrl = await getBaseUrl();
    
    if (apiKey == null) throw Exception('Jackett API key not set');
    if (baseUrl == null) throw Exception('Jackett URL not set');

    final queryParams = {
      'apikey': apiKey,
      'Query': year != null ? '$query $year' : query,
    };

    final uri = Uri.parse('$baseUrl/api/v2.0/indexers/all/results')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load search results');
    }
  }
} 