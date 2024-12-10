import 'package:hive/hive.dart';

part 'artist_bio_hive.g.dart';

@HiveType(typeId: 1)
class ArtistBioHive {
  @HiveField(0)
  final String? description;

  @HiveField(1)
  final String? birthday;

  @HiveField(2)
  final String? activeCountry;

  @HiveField(3)
  final String? countryCode;

  @HiveField(4)
  final String? birthPlace;

  @HiveField(5)
  final String? wikiUrl;

  @HiveField(6)
  final String? musicBrainzUrl;

  @HiveField(7)
  final bool hasRetriedWithEnglish;

  ArtistBioHive({
    this.description,
    this.birthday,
    this.activeCountry,
    this.countryCode,
    this.birthPlace,
    this.wikiUrl,
    this.musicBrainzUrl,
    required this.hasRetriedWithEnglish,
  });
}
