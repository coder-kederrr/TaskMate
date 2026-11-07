class UserModel {
  final String id;
  final String name;
  final String email;
  final String university;
  final String major;
  final int semester;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.major,
    this.semester = 5,
    this.photoUrl,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? university,
    String? major,
    int? semester,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      university: university ?? this.university,
      major: major ?? this.major,
      semester: semester ?? this.semester,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

