// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NovelBookAdapter extends TypeAdapter<NovelBook> {
  @override
  final int typeId = 12;

  @override
  NovelBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NovelBook(
      id: fields[0] as String,
      title: fields[1] as String,
      coverPath: fields[2] as String?,
      chapterCount: fields[3] as int,
      importedAt: fields[4] as DateTime,
      lastReadAt: fields[5] as DateTime?,
      lastReadChapterId: fields[6] as int,
      readProgress: fields[7] as double,
      rawFileName: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NovelBook obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.coverPath)
      ..writeByte(3)
      ..write(obj.chapterCount)
      ..writeByte(4)
      ..write(obj.importedAt)
      ..writeByte(5)
      ..write(obj.lastReadAt)
      ..writeByte(6)
      ..write(obj.lastReadChapterId)
      ..writeByte(7)
      ..write(obj.readProgress)
      ..writeByte(8)
      ..write(obj.rawFileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NovelBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
