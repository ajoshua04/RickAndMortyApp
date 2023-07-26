
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String origin;
  final String gender;
  final String type;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.origin,
    required this.gender,
    required this.type,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      origin: json['origin']['name'],
      gender: json['gender'],
      type: json['type'],
    );
  }
}
