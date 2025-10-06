import 'package:json_annotation/json_annotation.dart';

part 'news_item.g.dart';

@JsonSerializable()
class NewsItem {
  final int id;
  final String? title;
  final String? url;
  final String? by;
  final int? time;
  final int? score;
  final int? descendants;
  final List<int>? kids; // Add this line for comment IDs
  final String? text; // Add this line for comment text

  NewsItem({
    required this.id,
    this.title,
    this.url,
    this.by,
    this.time,
    this.score,
    this.descendants,
    this.kids, // Add this to the constructor
    this.text, // Add this to the constructor
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);
  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}
