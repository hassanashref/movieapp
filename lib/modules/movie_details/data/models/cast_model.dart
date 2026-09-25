class CastModel {
  final String name;
  final String character;
  final String image;

  CastModel({
    required this.name,
    required this.character,
    required this.image,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      image: json['image'] ?? '',
    );
  }
}