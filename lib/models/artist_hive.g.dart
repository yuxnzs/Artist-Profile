// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistHiveAdapter extends TypeAdapter<ArtistHive> {
  @override
  final int typeId = 2;

  @override
  ArtistHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtistHive(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String?,
      popularity: fields[3] as double,
      followers: fields[4] as int,
      genres: (fields[5] as List).cast<String>(),
      spotifyUrl: fields[6] as String,
      bio: fields[7] as ArtistBioHive?,
    );
  }

  @override
  void write(BinaryWriter writer, ArtistHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.popularity)
      ..writeByte(4)
      ..write(obj.followers)
      ..writeByte(5)
      ..write(obj.genres)
      ..writeByte(6)
      ..write(obj.spotifyUrl)
      ..writeByte(7)
      ..write(obj.bio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
