import 'package:hive/hive.dart';
import 'artist_bio_hive.dart';

part 'artist_hive.g.dart';

@HiveType(typeId: 2)
class ArtistHive {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? image;

  @HiveField(3)
  final double popularity;

  @HiveField(4)
  final int followers;

  @HiveField(5)
  final List<String> genres;

  @HiveField(6)
  final String spotifyUrl;

  @HiveField(7)
  final ArtistBioHive? bio;

  ArtistHive({
    required this.id,
    required this.name,
    this.image,
    required this.popularity,
    required this.followers,
    required this.genres,
    required this.spotifyUrl,
    this.bio,
  });
}
