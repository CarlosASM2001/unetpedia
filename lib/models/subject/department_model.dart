import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final String? id;
  final String? name;
  final String? email;

  DepartmentModel({this.id, this.name, this.email});

  DepartmentModel copyWith({String? id, String? name, String? email}) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory DepartmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DepartmentModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
    );
  }

  // Convert from JSON
  // factory DepartmentModel.fromJson(Map<String, dynamic> json) {
  //   return DepartmentModel(
  //     id: json['id'],
  //     name: json['name'],
  //     email: json['email'],
  //   );
  // }

  // Convert to JSON
  // Map<String, dynamic> toJson() {
  //   return {'id': id, 'name': name, 'email': email};
  // }
}
