class ArtistBio {
  final String description;
  final String birthday;
  final String activeCountry;
  final String countryCode;
  final String birthplace;

  ArtistBio({
    required this.description,
    required this.birthday,
    required this.activeCountry,
    required this.countryCode,
    required this.birthplace,
  });

  factory ArtistBio.fromJson(Map<String, dynamic> json) {
    return ArtistBio(
      description: json['description'],
      birthday: json['birthday'],
      activeCountry: json['activeCountry'],
      countryCode: json['countryCode'],
      birthplace: json['birthplace'],
    );
  }
}

class Artist {
  final String name;
  final String image;
  final double popularity;
  final int followers;
  final List<String> genres;
  final ArtistBio? bio;

  Artist({
    required this.name,
    required this.image,
    required this.popularity,
    required this.followers,
    required this.genres,
    this.bio,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      image: json['image'],
      popularity: json['popularity'].toDouble(),
      followers: json['followers'],
      genres: List<String>.from(json['genres']),
      bio: json['bio'] != null ? ArtistBio.fromJson(json['bio']) : null,
    );
  }
}
