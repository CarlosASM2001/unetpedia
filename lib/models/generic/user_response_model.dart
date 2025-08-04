import 'package:cloud_firestore/cloud_firestore.dart';

class UserResponseModel {
  final String? uid;
  final String? name;
  final String? lastName;
  final String? email;
  final String? photoUrl;
  final String? role;
  final String? description;
  final String? careerId;
  final DateTime? registerDate;
  final DateTime? lastSignIn;

  UserResponseModel({
    this.uid,
    this.name,
    this.lastName,
    this.email,
    this.photoUrl,
    this.role,
    this.description,
    this.careerId,
    this.registerDate,
    this.lastSignIn,
  });

  String get fullName => "$name $lastName";

  String get roleParsed {
    switch (role) {
      case "user":
        return "Usuario";
      case "admin":
        return "Administrador";
      case "mentor":
        return "Tutor";
      default:
        return "N/A";
    }
  }

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        uid: json['uid'],
        name: json['name'],
        lastName: json['lastName'],
        email: json['email'],
        photoUrl: json['photoUrl'],
        role: json['role'],
        description: json['description'],
        careerId: json['careerId'],
        registerDate: (json['registerDate'] as Timestamp?)?.toDate(),
        lastSignIn: (json['lastSignIn'] as Timestamp?)?.toDate(),
      );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "lastName": lastName,
    "email": email,
    "photoUrl": photoUrl,
    "role": role,
    "description": description,
    "careerId": careerId,
    "registerDate": registerDate,
    "lastSignIn": lastSignIn,
  };
}
