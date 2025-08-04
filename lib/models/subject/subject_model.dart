import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String? id;
  final String? name;
  final int? filesCount;

  SubjectModel({this.id, this.name, this.filesCount});

  String get getFileCount {
    if (filesCount == null) return "Sin Archivos";

    if (filesCount == 1) return "1 Archivo";

    return "$filesCount Archivos";
  }

  SubjectModel copyWith({String? id, String? name, int? filesCount}) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      filesCount: filesCount ?? this.filesCount,
    );
  }

  factory SubjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubjectModel(
      id: doc.id,
      name: data['name'],
      filesCount: data["file_count"],
    );
  }

  // Convert from JSON
  // factory SubjectModel.fromJson(Map<String, dynamic> json) {
  //   return SubjectModel(id: json['id'], name: json['name']);
  // }

  // Convert to JSON
  // Map<String, dynamic> toJson() {
  //   return {'id': id, 'name': name};
  // }
}
