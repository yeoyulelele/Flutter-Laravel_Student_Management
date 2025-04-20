class Student {
  final int? id;
  final String name;
  final String email;
  final String dob;

  Student({this.id, required this.name, required this.email, required this.dob});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      dob: json['dob'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dob': dob,
    };
  }
}
