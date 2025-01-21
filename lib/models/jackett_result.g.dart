// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jackett_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JackettResultImpl _$$JackettResultImplFromJson(Map<String, dynamic> json) =>
    _$JackettResultImpl(
      title: json['title'] as String,
      tracker: json['tracker'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      seeders: (json['seeders'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      link: json['link'] as String?,
      magnetUri: json['magnetUri'] as String?,
      description: json['description'] as String?,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isCached: json['isCached'] as bool? ?? false,
    );

Map<String, dynamic> _$$JackettResultImplToJson(_$JackettResultImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'tracker': instance.tracker,
      'publishDate': instance.publishDate.toIso8601String(),
      'seeders': instance.seeders,
      'size': instance.size,
      'link': instance.link,
      'magnetUri': instance.magnetUri,
      'description': instance.description,
      'languages': instance.languages,
      'categories': instance.categories,
      'isCached': instance.isCached,
    };
