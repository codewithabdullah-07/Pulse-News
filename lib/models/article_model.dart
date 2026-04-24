// lib/models/article_model.dart
// Core data model for a news article
// Annotated for Hive local storage (bookmarks)

import 'package:hive/hive.dart';

part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends HiveObject {
  @HiveField(0)
  final String? title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final String? urlToImage;

  @HiveField(3)
  final String? url;

  @HiveField(4)
  final String? content;

  @HiveField(5)
  final String? publishedAt;

  @HiveField(6)
  final SourceModel? source;

  @HiveField(7)
  final String? author;

  ArticleModel({
    this.title,
    this.description,
    this.urlToImage,
    this.url,
    this.content,
    this.publishedAt,
    this.source,
    this.author,
  });

  /// Factory: build from raw API JSON map
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      urlToImage: json['urlToImage'] as String?,
      url: json['url'] as String?,
      content: json['content'] as String?,
      publishedAt: json['publishedAt'] as String?,
      source: json['source'] != null
          ? SourceModel.fromJson(json['source'] as Map<String, dynamic>)
          : null,
      author: json['author'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'urlToImage': urlToImage,
        'url': url,
        'content': content,
        'publishedAt': publishedAt,
        'source': source?.toJson(),
        'author': author,
      };

  /// Clean content by removing the NewsAPI "[+N chars]" truncation suffix
  String get cleanContent {
    if (content == null) return description ?? 'No content available.';
    final idx = content!.lastIndexOf('[+');
    return idx != -1 ? content!.substring(0, idx).trim() : content!;
  }

  /// Returns true if the article has a valid image URL
  bool get hasImage =>
      urlToImage != null &&
      urlToImage!.isNotEmpty &&
      urlToImage!.startsWith('http');

  DateTime? get publishedDate {
    if (publishedAt == null) return null;
    try {
      return DateTime.parse(publishedAt!);
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModel &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;
}

// ─── Source sub-model ─────────────────────────────────────────────────────────

@HiveType(typeId: 1)
class SourceModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  const SourceModel({this.id, this.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
