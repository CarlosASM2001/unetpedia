import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String? id;
  final String? name;

  SubjectModel({this.id, this.name});

  SubjectModel copyWith({String? id, String? name}) {
    return SubjectModel(id: id ?? this.id, name: name ?? this.name);
  }

  // Convertir a Firestore document
  factory SubjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubjectModel(id: doc.id, name: data['name']);
  }

  // Convert from JSON
  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(id: json['id'], name: json['name']);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
