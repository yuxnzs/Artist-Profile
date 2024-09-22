class ArtistBio {
  final String? description;
  final String? birthday;
  final String? activeCountry;
  final String? countryCode;
  final String? birthPlace;
  final String? wikiUrl;
  final String? musicBrainzUrl;

  ArtistBio({
    this.description,
    this.birthday,
    this.activeCountry,
    this.countryCode,
    this.birthPlace,
    this.wikiUrl,
    this.musicBrainzUrl,
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
    );
  }
}

class Artist {
  final String name;
  final String? image;
  final double popularity;
  final int followers;
  final List<String> genres;
  final String spotifyUrl;
  final ArtistBio? bio;

  Artist({
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
      name: json['name'],
      image: json['image'],
      popularity: json['popularity'].toDouble(),
      followers: json['followers'],
      genres: List<String>.from(json['genres']),
      spotifyUrl: json['spotifyUrl'],
      bio: json['bio'] != null ? ArtistBio.fromJson(json['bio']) : null,
    );
  }
}
