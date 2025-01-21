import '../models/jackett_result.dart';

enum SortField {
  seeders,
  size,
}

enum SortOrder {
  ascending,
  descending,
}

class MediaFilters {
  final int minimumSeeders;
  final double? minimumSizeGB;
  final double? maximumSizeGB;
  final SortField sortBy;
  final SortOrder sortOrder;

  const MediaFilters({
    this.minimumSeeders = 0,
    this.minimumSizeGB,
    this.maximumSizeGB,
    this.sortBy = SortField.seeders,
    this.sortOrder = SortOrder.descending,
  });

  MediaFilters copyWith({
    int? minimumSeeders,
    double? minimumSizeGB,
    double? maximumSizeGB,
    SortField? sortBy,
    SortOrder? sortOrder,
  }) {
    return MediaFilters(
      minimumSeeders: minimumSeeders ?? this.minimumSeeders,
      minimumSizeGB: minimumSizeGB ?? this.minimumSizeGB,
      maximumSizeGB: maximumSizeGB ?? this.maximumSizeGB,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  bool matchesFilters(double sizeGB) {
    if (minimumSizeGB != null && sizeGB < minimumSizeGB!) {
      return false;
    }
    if (maximumSizeGB != null && sizeGB > maximumSizeGB!) {
      return false;
    }
    return true;
  }

  int compareResults(JackettResult a, JackettResult b) {
    int comparison;
    switch (sortBy) {
      case SortField.seeders:
        comparison = a.seeders.compareTo(b.seeders);
        break;
      case SortField.size:
        comparison = a.size.compareTo(b.size);
        break;
    }
    return sortOrder == SortOrder.ascending ? comparison : -comparison;
  }
}

class SearchSettings {
  final MediaFilters movieFilters;
  final MediaFilters tvShowFilters;

  const SearchSettings({
    required this.movieFilters,
    required this.tvShowFilters,
  });

  factory SearchSettings.defaults() {
    return const SearchSettings(
      movieFilters: MediaFilters(
        minimumSeeders: 1,
        minimumSizeGB: 0,
        maximumSizeGB: 100.0,
      ),
      tvShowFilters: MediaFilters(
        minimumSeeders: 1,
        minimumSizeGB: 0.1,
        maximumSizeGB: 100.0,
      ),
    );
  }

  MediaFilters getFiltersForType(bool isMovie) {
    return isMovie ? movieFilters : tvShowFilters;
  }
} 