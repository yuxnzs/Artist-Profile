class Artist {
  final String name;
  final String image;
  final double popularity;
  final int followers;
  final List<String> genres;
  final String bio;

  Artist({
    required this.name,
    required this.image,
    required this.popularity,
    required this.followers,
    required this.genres,
    required this.bio,
  });

  // factory constructor to create an Artist object from a JSON map
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      image: json['image'],
      popularity: json['popularity'],
      followers: json['followers'],
      genres: json['genres'],
      bio: json['bio'],
    );
  }
}

// Temporary data; will be replaced by data from API
Map<String, Map<String, dynamic>> artistsData = {
  "Taylor Swift": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebe672b5f553298dcdccb0e676",
    "popularity": 10.0,
    "followers": 119867977,
    "genres": ["pop"],
    "bio":
        "Taylor Swift is an American singer-songwriter known for her narrative songwriting, which often centers around her personal life."
  },
  "Olivia Rodrigo": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebe03a98785f3658f0b6461ec4",
    "popularity": 8.7,
    "followers": 39055161,
    "genres": ["pop"],
    "bio":
        "Olivia Rodrigo is an American singer-songwriter and actress who gained recognition with her debut single 'Drivers License'."
  },
  "Ariana Grande": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb40b5c07ab77b6b1a9075fdc0",
    "popularity": 9.1,
    "followers": 99148270,
    "genres": ["pop"],
    "bio":
        "Ariana Grande is an American singer and actress known for her wide vocal range and hit singles like 'Thank U, Next' and '7 Rings'."
  },
  "Billie Eilish": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb4a21b4760d2ecb7b0dcdc8da",
    "popularity": 9.5,
    "followers": 98479711,
    "genres": ["art pop", "pop"],
    "bio":
        "Billie Eilish is an American singer-songwriter known for her distinctive voice and songs like 'Bad Guy' and 'Ocean Eyes'."
  },
  "Shawn Mendes": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebd56712ef06c48938329731e1",
    "popularity": 8.3,
    "followers": 43127679,
    "genres": ["canadian pop", "pop", "viral pop"],
    "bio":
        "Shawn Mendes is a Canadian singer-songwriter known for hits like 'Stitches' and 'Senorita'."
  },
  "Justin Bieber": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb8ae7f2aaa9817a704a87ea36",
    "popularity": 8.9,
    "followers": 76847948,
    "genres": ["canadian pop", "pop"],
    "bio":
        "Justin Bieber is a Canadian singer who gained fame with his debut single 'Baby' and has continued to release successful pop music."
  },
  "SZA": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb0895066d172e1f51f520bc65",
    "popularity": 8.9,
    "followers": 22556679,
    "genres": ["pop", "r&b", "rap"],
    "bio":
        "SZA is an American singer-songwriter known for her neo-soul and alternative R&B sound, highlighted in her debut album 'Ctrl'."
  },
  "The Weeknd": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb214f3cf1cbe7139c1e26ffbb",
    "popularity": 9.4,
    "followers": 89654444,
    "genres": ["canadian contemporary r&b", "canadian pop", "pop"],
    "bio":
        "The Weeknd is a Canadian singer known for his unique blend of R&B, pop, and alternative music, with hits like 'Blinding Lights'."
  },
  "Brandy": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebb39417aaafb9c373e78594ef",
    "popularity": 6.9,
    "followers": 3691009,
    "genres": [
      "contemporary r&b",
      "dance pop",
      "hip pop",
      "r&b",
      "urban contemporary"
    ],
    "bio":
        "Brandy is an American singer and actress who has been a prominent figure in R&B since the 1990s, known for her soulful voice."
  },
  "Beyoncé": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb247f44069c0bd1781df2f785",
    "popularity": 8.6,
    "followers": 38385324,
    "genres": ["pop", "r&b"],
    "bio":
        "Beyoncé is an American singer, songwriter, and actress, widely regarded as one of the greatest entertainers of her generation."
  },
  "Nicki Minaj": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb07a50f0a9a8f11e5a1102cbd",
    "popularity": 8.6,
    "followers": 32157255,
    "genres": ["hip pop", "pop", "queens hip hop", "rap"],
    "bio":
        "Nicki Minaj is a Trinidadian-American rapper and singer known for her versatility in flow and animated rap style."
  },
  "Cardi B": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb4e8a7e14e2f602eb9af24e31",
    "popularity": 8.0,
    "followers": 24376686,
    "genres": ["pop", "rap"],
    "bio":
        "Cardi B is an American rapper known for her aggressive flow and candid lyrics, with hits like 'Bodak Yellow' and 'WAP'."
  },
  "Drake": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9",
    "popularity": 9.5,
    "followers": 91234111,
    "genres": ["canadian hip hop", "canadian pop", "hip hop", "pop rap", "rap"],
    "bio":
        "Drake is a Canadian rapper, singer, and songwriter known for his emotionally-driven lyrics and blending of hip-hop and R&B."
  },
  "Travis Scott": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb19c2790744c792d05570bb71",
    "popularity": 9.4,
    "followers": 32233030,
    "genres": ["rap", "slap house"],
    "bio":
        "Travis Scott is an American rapper and producer known for his psychedelic trap music and high-energy performances."
  },
  "Ice Spice": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb99878733414d6d04a20a5c3e",
    "popularity": 7.7,
    "followers": 4041057,
    "genres": ["bronx drill"],
    "bio":
        "Ice Spice is an American rapper known for her distinct voice and energetic rap style."
  },
  "Megan Thee Stallion": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb3bd9fe71c49b7940786b852f",
    "popularity": 8.2,
    "followers": 9623124,
    "genres": ["houston rap", "pop", "r&b", "rap", "trap queen"],
    "bio":
        "Megan Thee Stallion is an American rapper known for her confident and bold lyrics, with hits like 'Savage' and 'Hot Girl Summer'."
  },
  "Calvin Harris": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb014a3c1730d960c66396ed63",
    "popularity": 8.7,
    "followers": 22800476,
    "genres": [
      "dance pop",
      "edm",
      "electro house",
      "house",
      "pop",
      "progressive house",
      "uk dance"
    ],
    "bio":
        "Calvin Harris is a Scottish DJ and producer known for his hit EDM tracks and collaborations with major pop artists."
  },
  "David Guetta": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebf150017ca69c8793503c2d4f",
    "popularity": 9.0,
    "followers": 26055559,
    "genres": ["big room", "dance pop", "edm", "pop", "pop dance"],
    "bio":
        "David Guetta is a French DJ and producer who has been a prominent figure in the EDM scene, known for tracks like 'Titanium'."
  },
  "Marshmello": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb69b18a96278c204074a6f265",
    "popularity": 8.4,
    "followers": 33775198,
    "genres": ["brostep", "edm", "pop", "progressive electro house"],
    "bio":
        "Marshmello is an American DJ and producer known for his masked appearance and hits like 'Happier' and 'Alone'."
  },
  "Zedd": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebe6d6f36e6be274af881e3dd0",
    "popularity": 7.4,
    "followers": 5948108,
    "genres": ["complextro", "edm", "german techno", "pop", "pop dance"],
    "bio":
        "Zedd is a Russian-German DJ and producer known for his electro house music and pop collaborations."
  },
  "Tim McGraw": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebbd6977f3970a7a4a8d4becbe",
    "popularity": 7.4,
    "followers": 4601890,
    "genres": [
      "contemporary country",
      "country",
      "country road",
      "modern country rock"
    ],
    "bio":
        "Tim McGraw is an American country singer and actor known for his deep voice and hits like 'Live Like You Were Dying'."
  },
  "Luke Bryan": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb9754cf0a7b838caafa4b8b55",
    "popularity": 7.7,
    "followers": 8799607,
    "genres": [
      "contemporary country",
      "country",
      "country road",
      "modern country rock"
    ],
    "bio":
        "Luke Bryan is an American country singer known for his upbeat songs and ballads, with hits like 'Country Girl'."
  },
  "Carrie Underwood": {
    "image": "https://i.scdn.co/image/ab6761610000e5eb6d81a16f9d1b2abf04e765a6",
    "popularity": 7.0,
    "followers": 5977149,
    "genres": [
      "classic oklahoma country",
      "contemporary country",
      "country",
      "country dawn",
      "dance pop",
      "pop"
    ],
    "bio":
        "Carrie Underwood is an American country singer who rose to fame after winning American Idol, known for hits like 'Before He Cheats'."
  },
  "Blake Shelton": {
    "image": "https://i.scdn.co/image/ab6761610000e5ebe2cff2190102be30cfb8bfe5",
    "popularity": 7.4,
    "followers": 7199365,
    "genres": [
      "classic oklahoma country",
      "contemporary country",
      "country",
      "country road",
      "modern country rock"
    ],
    "bio":
        "Blake Shelton is an American country singer and television personality, known for hits like 'God's Country' and his role on 'The Voice'."
  }
};

// Convert the artists data to a list of Artist objects
List<Artist> artistsList = artistsData.entries.map((entry) {
  return Artist.fromJson({
    'name': entry.key,
    ...entry.value,
  });
}).toList();
