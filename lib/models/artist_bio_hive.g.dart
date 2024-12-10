// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_bio_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistBioHiveAdapter extends TypeAdapter<ArtistBioHive> {
  @override
  final int typeId = 1;

  @override
  ArtistBioHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtistBioHive(
      description: fields[0] as String?,
      birthday: fields[1] as String?,
      activeCountry: fields[2] as String?,
      countryCode: fields[3] as String?,
      birthPlace: fields[4] as String?,
      wikiUrl: fields[5] as String?,
      musicBrainzUrl: fields[6] as String?,
      hasRetriedWithEnglish: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ArtistBioHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.birthday)
      ..writeByte(2)
      ..write(obj.activeCountry)
      ..writeByte(3)
      ..write(obj.countryCode)
      ..writeByte(4)
      ..write(obj.birthPlace)
      ..writeByte(5)
      ..write(obj.wikiUrl)
      ..writeByte(6)
      ..write(obj.musicBrainzUrl)
      ..writeByte(7)
      ..write(obj.hasRetriedWithEnglish);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistBioHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
