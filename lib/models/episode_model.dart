class Episode {
  final int id;
  final String name;
  final String episode;
  final String airDate; 

  Episode({
    required this.id,
    required this.name,
    required this.episode,
    required this.airDate, 
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      episode: json['episode'],
      airDate: json['air_date'], 
    );
  }
}
