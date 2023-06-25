import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String profilePic;
  UserModel({
    required this.id,
    required this.name,
    required this.profilePic,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? profilePic,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'profilePic': profilePic});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, profilePic: $profilePic)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ profilePic.hashCode;
}
