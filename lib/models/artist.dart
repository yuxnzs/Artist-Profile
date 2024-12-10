import 'package:artist_profile/models/artist_bio_hive.dart';
import 'package:artist_profile/models/artist_hive.dart';

class ArtistBio {
  final String? description;
  final String? birthday;
  final String? activeCountry;
  final String? countryCode;
  final String? birthPlace;
  final String? wikiUrl;
  final String? musicBrainzUrl;
  final bool hasRetriedWithEnglish;

  ArtistBio({
    this.description,
    this.birthday,
    this.activeCountry,
    this.countryCode,
    this.birthPlace,
    this.wikiUrl,
    this.musicBrainzUrl,
    required this.hasRetriedWithEnglish,
  });

  factory ArtistBio.fromJson(Map<String, dynamic> json) {
    return ArtistBio(
      description: json['description'],
      birthday: json['birthday'],
      activeCountry: json['activeCountry'],
      countryCode: json['countryCode'],
      birthPlace: json['birthPlace'],
      wikiUrl: json['wikiUrl'],
      musicBrainzUrl: json['musicbrainzUrl'],
      hasRetriedWithEnglish: json['hasRetriedWithEnglish'],
    );
  }

  // Convert ArtistBio to ArtistBioHive
  ArtistBioHive toHiveModel() {
    return ArtistBioHive(
      description: description,
      birthday: birthday,
      activeCountry: activeCountry,
      countryCode: countryCode,
      birthPlace: birthPlace,
      wikiUrl: wikiUrl,
      musicBrainzUrl: musicBrainzUrl,
      hasRetriedWithEnglish: hasRetriedWithEnglish,
    );
  }

  // Convert ArtistBioHive to ArtistBio
  factory ArtistBio.fromHiveModel(ArtistBioHive hiveModel) {
    return ArtistBio(
      description: hiveModel.description,
      birthday: hiveModel.birthday,
      activeCountry: hiveModel.activeCountry,
      countryCode: hiveModel.countryCode,
      birthPlace: hiveModel.birthPlace,
      wikiUrl: hiveModel.wikiUrl,
      musicBrainzUrl: hiveModel.musicBrainzUrl,
      hasRetriedWithEnglish: hiveModel.hasRetriedWithEnglish,
    );
  }
}

class Artist {
  final String id;
  final String name;
  final String? image;
  final double popularity;
  final int followers;
  final List<String> genres;
  final String spotifyUrl;
  final ArtistBio? bio;

  Artist({
    required this.id,
    required this.name,
    this.image,
    required this.popularity,
    required this.followers,
    required this.genres,
    required this.spotifyUrl,
    this.bio,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      popularity: json['popularity'].toDouble(),
      followers: json['followers'],
      genres: List<String>.from(json['genres']),
      spotifyUrl: json['spotifyUrl'],
      bio: json['bio'] != null ? ArtistBio.fromJson(json['bio']) : null,
    );
  }

  // Convert Artist to ArtistHive
  ArtistHive toHiveModel() {
    return ArtistHive(
      id: id,
      name: name,
      image: image,
      popularity: popularity,
      followers: followers,
      genres: genres,
      spotifyUrl: spotifyUrl,
      bio: bio?.toHiveModel(),
    );
  }

  // Convert ArtistHive to Artist
  factory Artist.fromHiveModel(ArtistHive hiveModel) {
    return Artist(
      id: hiveModel.id,
      name: hiveModel.name,
      image: hiveModel.image,
      popularity: hiveModel.popularity,
      followers: hiveModel.followers,
      genres: hiveModel.genres,
      spotifyUrl: hiveModel.spotifyUrl,
      bio: hiveModel.bio != null
          ? ArtistBio.fromHiveModel(hiveModel.bio!)
          : null,
    );
  }
}
