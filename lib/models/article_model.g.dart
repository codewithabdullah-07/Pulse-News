// lib/models/article_model.g.dart
// GENERATED CODE - Hive TypeAdapter for ArticleModel & SourceModel
// Run: flutter pub run build_runner build --delete-conflicting-outputs

part of 'article_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final int typeId = 0;

  @override
  ArticleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleModel(
      title: fields[0] as String?,
      description: fields[1] as String?,
      urlToImage: fields[2] as String?,
      url: fields[3] as String?,
      content: fields[4] as String?,
      publishedAt: fields[5] as String?,
      source: fields[6] as SourceModel?,
      author: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.urlToImage)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.publishedAt)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.author);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SourceModelAdapter extends TypeAdapter<SourceModel> {
  @override
  final int typeId = 1;

  @override
  SourceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SourceModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SourceModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
