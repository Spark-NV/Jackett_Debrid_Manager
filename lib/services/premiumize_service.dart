import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/premiumize_models.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/premiumize_provider.dart';

class PremiumizeService {
  static const String _baseUrl = 'https://www.premiumize.me/api';
  static const _apiKeyPrefKey = 'premiumize_api_key';
  final CacheNotifier cacheNotifier;

  PremiumizeService(this.cacheNotifier);
  
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPrefKey);
  }

  Future<PremiumizeAccountInfo> getAccountInfo() async {
    final apiKey = await getApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/account/info');

    final response = await http.get(
      uri,
      headers: {'apikey': apiKey},
    );

    if (response.statusCode == 200) {
      return PremiumizeAccountInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load account info');
    }
  }

  String? _extractHash(String? magnetUrl) {
    if (magnetUrl == null) return null;
    
    final match = RegExp(r'btih:([a-fA-F0-9]{40})')
        .firstMatch(magnetUrl);
    final hash = match?.group(1)?.toUpperCase();
    return hash;
  }

  Future<Map<String, bool>> checkCacheBatch(List<String> magnetUrls) async {
    final apiKey = await getApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uniqueHashes = <String>{};
    final hashToMagnet = <String, List<String>>{};

    for (final magnetUrl in magnetUrls) {
      final hash = _extractHash(magnetUrl);
      if (hash != null) {
        uniqueHashes.add(hash);
        (hashToMagnet[hash] ??= []).add(magnetUrl);
      }
    }

    if (uniqueHashes.isEmpty) return {};

    final uri = Uri.parse('$_baseUrl/cache/check');

    final requestBody = <String, String>{
      'apikey': apiKey,
    };
    
    var index = 0;
    for (final hash in uniqueHashes) {
      requestBody['items[$index]'] = hash;
      index++;
    }

    print(const JsonEncoder.withIndent('  ').convert(requestBody));

    final response = await http.post(
      uri,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] != 'success') {
        throw Exception('API returned error status');
      }

      final responseList = jsonData['response'] as List;
      
      final results = <String, bool>{};
      var i = 0;
      for (final hash in uniqueHashes) {
        if (i < responseList.length) {
          final isCached = responseList[i] as bool;
          final magnetUrls = hashToMagnet[hash];
          if (magnetUrls != null) {
            for (final magnetUrl in magnetUrls) {
              results[magnetUrl] = isCached;
            }
          }
        }
        i++;
      }
      
      return results;
    } else {
      throw Exception('Failed to check cache');
    }
  }

  Future<bool> checkCache(String magnetUrl) async {
    final results = await checkCacheBatch([magnetUrl]);
    return results[magnetUrl] ?? false;
  }

  Future<PremiumizeTransfer> addMagnetLink(String magnetUrl) async {
    final apiKey = await getApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/transfer/create');

    final requestBody = {
      'apikey': apiKey,
      'src': magnetUrl,
    };
    print(const JsonEncoder.withIndent('  ').convert(requestBody));

    final response = await http.post(
      uri,
      body: requestBody,
    );


    try {
      final jsonData = json.decode(response.body);
      print(const JsonEncoder.withIndent('  ').convert(jsonData));
    } catch (e) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        throw Exception(data['message'] ?? 'Failed to add magnet link');
      }
      return PremiumizeTransfer.fromJson(data);
    } else {
      throw Exception('Failed to add magnet link');
    }
  }

  Future<List<PremiumizeTransfer>> getTransfers() async {
    final apiKey = await getApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/transfer/list').replace(
      queryParameters: {'apikey': apiKey},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final transfers = (data['transfers'] as List)
            .map((t) => PremiumizeTransfer.fromJson(t as Map<String, dynamic>))
            .toList();
        return transfers;
      }
      throw Exception('Failed to get transfers: ${data['message'] ?? 'Unknown error'}');
    }
    throw Exception('Failed to get transfers: ${response.statusCode}');
  }

  Future<void> clearFinishedTransfers() async {
    final apiKey = await getApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/transfer/clearfinished');

    final response = await http.post(
      uri,
      body: {'apikey': apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to clear finished transfers');
    }
  }

  Future<void> deleteTransfer(String id) async {
    final apiKey = await getApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$_baseUrl/transfer/delete');

    final response = await http.post(
      uri,
      body: {
        'apikey': apiKey,
        'id': id,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transfer');
    }
  }
} 