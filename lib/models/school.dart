class School {
  final String? id;
  final String name;
  final String address;
  final int numberOfStudents;
  final double latitude;
  final double longitude;

  School({
    this.id,
    required this.name,
    required this.address,
    required this.numberOfStudents,
    required this.latitude,
    required this.longitude,
  });

  // Construtor para criar uma instância de School a partir de um JSON
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      numberOfStudents: json['numberOfStudents'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Método para converter uma instância de School em um JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'numberOfStudents': numberOfStudents,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}