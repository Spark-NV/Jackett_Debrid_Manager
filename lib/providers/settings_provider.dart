import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SearchSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<SearchSettings> {
  static const _movieMinSeedersKey = 'movie_min_seeders';
  static const _movieMinSizeKey = 'movie_min_size';
  static const _movieMaxSizeKey = 'movie_max_size';
  static const _movieSortByKey = 'movie_sort_by';
  static const _movieSortOrderKey = 'movie_sort_order';
  static const _tvMinSeedersKey = 'tv_min_seeders';
  static const _tvMinSizeKey = 'tv_min_size';
  static const _tvMaxSizeKey = 'tv_max_size';
  static const _tvSortByKey = 'tv_sort_by';
  static const _tvSortOrderKey = 'tv_sort_order';

  SettingsNotifier() : super(SearchSettings.defaults()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    state = SearchSettings(
      movieFilters: MediaFilters(
        minimumSeeders: prefs.getInt(_movieMinSeedersKey) ?? 1,
        minimumSizeGB: prefs.getDouble(_movieMinSizeKey) ?? 0,
        maximumSizeGB: prefs.getDouble(_movieMaxSizeKey) ?? 100.0,
        sortBy: SortField.values[prefs.getInt(_movieSortByKey) ?? 0],
        sortOrder: SortOrder.values[prefs.getInt(_movieSortOrderKey) ?? 1],
      ),
      tvShowFilters: MediaFilters(
        minimumSeeders: prefs.getInt(_tvMinSeedersKey) ?? 1,
        minimumSizeGB: prefs.getDouble(_tvMinSizeKey) ?? 0.1,
        maximumSizeGB: prefs.getDouble(_tvMaxSizeKey) ?? 100.0,
        sortBy: SortField.values[prefs.getInt(_tvSortByKey) ?? 0],
        sortOrder: SortOrder.values[prefs.getInt(_tvSortOrderKey) ?? 1],
      ),
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt(_movieMinSeedersKey, state.movieFilters.minimumSeeders);
    await prefs.setDouble(_movieMinSizeKey, state.movieFilters.minimumSizeGB ?? 0);
    await prefs.setDouble(_movieMaxSizeKey, state.movieFilters.maximumSizeGB ?? 100.0);
    
    await prefs.setInt(_tvMinSeedersKey, state.tvShowFilters.minimumSeeders);
    await prefs.setDouble(_tvMinSizeKey, state.tvShowFilters.minimumSizeGB ?? 0.1);
    await prefs.setDouble(_tvMaxSizeKey, state.tvShowFilters.maximumSizeGB ?? 100.0);
    
    await prefs.setInt(_movieSortByKey, state.movieFilters.sortBy.index);
    await prefs.setInt(_movieSortOrderKey, state.movieFilters.sortOrder.index);
    await prefs.setInt(_tvSortByKey, state.tvShowFilters.sortBy.index);
    await prefs.setInt(_tvSortOrderKey, state.tvShowFilters.sortOrder.index);
  }

  void updateMovieFilters({
    int? minimumSeeders,
    double? minimumSizeGB,
    double? maximumSizeGB,
    SortField? sortBy,
    SortOrder? sortOrder,
  }) {
    state = SearchSettings(
      movieFilters: MediaFilters(
        minimumSeeders: minimumSeeders ?? state.movieFilters.minimumSeeders,
        minimumSizeGB: minimumSizeGB ?? state.movieFilters.minimumSizeGB,
        maximumSizeGB: maximumSizeGB ?? state.movieFilters.maximumSizeGB,
        sortBy: sortBy ?? state.movieFilters.sortBy,
        sortOrder: sortOrder ?? state.movieFilters.sortOrder,
      ),
      tvShowFilters: state.tvShowFilters,
    );
    _saveSettings();
  }

  void updateTVShowFilters({
    int? minimumSeeders,
    double? minimumSizeGB,
    double? maximumSizeGB,
    SortField? sortBy,
    SortOrder? sortOrder,
  }) {
    state = SearchSettings(
      movieFilters: state.movieFilters,
      tvShowFilters: MediaFilters(
        minimumSeeders: minimumSeeders ?? state.tvShowFilters.minimumSeeders,
        minimumSizeGB: minimumSizeGB ?? state.tvShowFilters.minimumSizeGB,
        maximumSizeGB: maximumSizeGB ?? state.tvShowFilters.maximumSizeGB,
        sortBy: sortBy ?? state.tvShowFilters.sortBy,
        sortOrder: sortOrder ?? state.tvShowFilters.sortOrder,
      ),
    );
    _saveSettings();
  }
} 