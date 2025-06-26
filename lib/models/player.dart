class Player {
  final String? id;
  final String name;
  final String email;
  final String? password;
  final DateTime dateOfBirth;

  Player({
    this.id,
    required this.name,
    required this.email,
    this.password,
    required this.dateOfBirth,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'dateOfBirth':
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
      };
} 