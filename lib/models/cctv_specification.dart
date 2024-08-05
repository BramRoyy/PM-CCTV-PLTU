class CCTVSpecification {
  final String id;
  final String name;
  final String resolution;
  final String lensType;

  final String description;

  CCTVSpecification({
    required this.id,
    required this.name,
    required this.resolution,
    required this.lensType,
    required this.description,
  });

  factory CCTVSpecification.fromJson(Map<String, dynamic> json) {
    return CCTVSpecification(
      id: json['id'],
      name: json['name'],
      resolution: json['resolution'],
      lensType: json['lens_type'],
      description: json['description'],
    );
  }
}
