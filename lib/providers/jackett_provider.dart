import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/jackett_service.dart';
import '../services/premiumize_service.dart';
import '../models/jackett_result.dart';
import '../providers/premiumize_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'jackett_provider.g.dart';

final jackettServiceProvider = Provider<JackettService>((ref) {
  return JackettService();
});

final searchResultsProvider = FutureProvider.family<Map<String, List<JackettResult>>, SearchParams>((ref, params) async {
  final service = ref.read(jackettServiceProvider);
  final results = await service.search(
    params.formattedQuery,
    year: params.year,
  );
  
  final jackettResults = (results['Results'] as List)
      .map((e) => JackettResult.fromJson(e as Map<String, dynamic>))
      .toList();
      
  final magnetUrls = jackettResults
      .map((r) => r.magnetUri)
      .whereType<String>()
      .toSet()
      .toList();

  if (magnetUrls.isNotEmpty) {
    final premiumizeService = ref.read(premiumizeServiceProvider);
    final cacheResults = await premiumizeService.checkCacheBatch(magnetUrls);
    
    final updatedResults = jackettResults.map((result) => 
      result.copyWith(
        isCached: result.magnetUri != null 
            ? cacheResults[result.magnetUri] ?? false
            : false,
      )
    ).toList();
    
    return {
      'Results': updatedResults,
    };
  }
  
  return {
    'Results': jackettResults,
  };
});

class SearchParams {
  final String query;
  final int? year;
  final bool isMovie;
  final bool isEpisodeSearch;
  final bool isSeasonSearch;
  final int? season;
  final int? episode;

  const SearchParams({
    required this.query,
    this.year,
    required this.isMovie,
    this.isEpisodeSearch = false,
    this.isSeasonSearch = false,
    this.season,
    this.episode,
  });

  String get formattedQuery {
    if (!isMovie) {
      if (isEpisodeSearch && season != null && episode != null) {
        return '$query S${season.toString().padLeft(2, '0')}E${episode.toString().padLeft(2, '0')}';
      }
      if (isSeasonSearch && season != null) {
        return '$query season ${season.toString()}';
      }
    }
    return query;
  }
}

class JackettSettings {
  final String? baseUrl;
  final String? apiKey;

  const JackettSettings({
    this.baseUrl,
    this.apiKey,
  });
}

@riverpod
Future<JackettSettings> jackettSettings(JackettSettingsRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return JackettSettings(
    baseUrl: prefs.getString('jackett_base_url'),
    apiKey: prefs.getString('jackett_api_key'),
  );
} 