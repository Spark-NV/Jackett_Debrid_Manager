import 'package:freezed_annotation/freezed_annotation.dart';

part 'jackett_result.freezed.dart';
part 'jackett_result.g.dart';

@freezed
class JackettResult with _$JackettResult {
  const factory JackettResult({
    required String title,
    required String tracker,
    required DateTime publishDate,
    required int seeders,
    required int size,
    String? link,
    String? magnetUri,
    String? description,
    @Default([]) List<String> languages,
    @Default([]) List<String> categories,
    @Default(false) bool isCached,
  }) = _JackettResult;

  factory JackettResult.fromJson(Map<String, dynamic> json) => JackettResult(
    title: json['Title'] as String,
    tracker: json['Tracker'] as String,
    size: json['Size'] as int,
    seeders: json['Seeders'] as int? ?? 0,
    link: json['Link'] as String?,
    magnetUri: json['MagnetUri'] as String?,
    description: json['Description'] as String?,
    publishDate: DateTime.parse(json['PublishDate'] as String),
    languages: (json['Languages'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    categories: (json['Category'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    isCached: json['isCached'] as bool? ?? false,
  );
}

extension JackettResultExtension on JackettResult {
  String get formattedSize {
    final gb = size / (1024 * 1024 * 1024);
    if (gb >= 1) {
      return '${gb.toStringAsFixed(2)} GB';
    }
    final mb = size / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }
} 