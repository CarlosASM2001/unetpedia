import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String? id;
  final String? name;
  final int? fileCount;

  SubjectModel({this.id, this.name, this.fileCount});

  String get getFileCount {
    if (fileCount == null || fileCount == 0) return "Sin Archivos";

    if (fileCount == 1) return "1 Archivo";

    return "$fileCount Archivos";
  }

  SubjectModel copyWith({String? id, String? name, int? fileCount}) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fileCount: fileCount ?? this.fileCount,
    );
  }

  factory SubjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubjectModel(
      id: doc.id,
      name: data['name'],
      fileCount: data["file_count"],
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
