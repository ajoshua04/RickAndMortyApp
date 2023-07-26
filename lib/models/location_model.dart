class Location {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final String url;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.url,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      dimension: json['dimension'],
      url: json['url'],
    );
  }
}
