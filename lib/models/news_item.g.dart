// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => NewsItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      url: json['url'] as String?,
      by: json['by'] as String?,
      time: (json['time'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toInt(),
      descendants: (json['descendants'] as num?)?.toInt(),
      kids: (json['kids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'by': instance.by,
      'time': instance.time,
      'score': instance.score,
      'descendants': instance.descendants,
      'kids': instance.kids,
      'text': instance.text,
    };
