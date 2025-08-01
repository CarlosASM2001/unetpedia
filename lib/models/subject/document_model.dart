import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String? id;
  final String? name;
  final String? url;
  final DocumentReference? subject;
  final DocumentReference? department;
  final DocumentReference? owner;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DocumentModel({
    this.id,
    this.name,
    this.url,
    this.subject,
    this.department,
    this.owner,
    this.createdAt,
    this.updatedAt,
  });

  /*String get departmentId {
    if ((department ?? "").isEmpty) return "N/A";

    final values = department!.split("/");
    return values.last;
  }

  String get subjectId {
    if ((subject ?? "").isEmpty) return "N/A";

    final values = subject!.split("/");
    return values.last;
  }*/

  factory DocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DocumentModel(
      id: doc.id,
      name: data['name'],
      url: data["url"],
      subject: data["subject"],
      department: data["department"],
      owner: data["owner"],
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    subject: json["subject"],
    department: json["department"],
    owner: json["owner"],
    createdAt: (json['created_at'] as Timestamp?)?.toDate(),
    updatedAt: (json['updated_at'] as Timestamp?)?.toDate(),
  );
}
