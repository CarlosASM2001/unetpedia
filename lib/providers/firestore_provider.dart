import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unetpedia/models/subject/subject.dart';
import 'package:unetpedia/models/generic/career_model.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/generic/user_response_model.dart';
import 'package:unetpedia/models/generic/data_exception_model.dart';
import 'package:unetpedia/models/authentication/register_request_model.dart';

class FirestoreProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _userCollection = "users";
  final String _careersCollection = "careers";
  final String _departmentsCollection = "departments";
  final String _subjectsCollection = "subjects";
  final String _filesCollection = "files";

  // ========================================================================
  //  Users
  // ========================================================================

  Future<void> createUserDocument(RegisterRequestModel user, String uid) async {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);

    return await ref.set({
      "uid": uid,
      "name": user.name,
      "lastName": user.lastName,
      "email": user.email,
      "photoUrl": user.photoUrl,
      "role": user.role,
      "description": user.description,
      "careerId": user.careerId,
      "registerDate": DateTime.now(),
      "lastSignIn": DateTime.now(),
      "platform": "app",
    }, SetOptions(merge: true));
  }

  // Updates users profile url in user document
  Future<void> updateProfileUrl(String uid, String url) async {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);

    await ref.update({"photoUrl": url});
  }

  // Updates users last login date
  Future<void> updateLastSignIn(String uid) async {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);

    await ref.update({"lastSignIn": DateTime.now()});
  }

  /// This function returns the url of the file uploaded
  Future<String> uploadFile({
    required StoragePath storagePath,
    required String path,
    required File file,
  }) async {
    late String url;

    try {
      // Creating path -> storagePath/path/image.jpg
      final Reference reference = _storage
          .ref()
          .child(storagePath.toPath())
          .child(path);

      // Uploading Asset
      final UploadTask imageToUpload = reference.putFile(file);

      // Getting download url
      await imageToUpload.then(
        (task) async => url = await task.ref.getDownloadURL(),
      );

      return url;
    } catch (e) {
      return "Error ${e.toString()}";
    }
  }

  // Get user informacion
  Future<Either<DataException, UserResponseModel>> getUser(String uid) async {
    try {
      final DocumentSnapshot doc = await _db
          .collection(_userCollection)
          .doc(uid)
          .get();

      return Right(
        UserResponseModel.fromJson(doc.data() as Map<String, dynamic>),
      );
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Edit user profile document
  Future<void> updateProfile({
    required String uid,
    String? name,
    String? lastName,
  }) async {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);

    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (lastName != null) data['lastName'] = lastName;

    await ref.update(data);
  }

  // ========================================================================
  //  Careers
  // ========================================================================

  // Get active careers by name
  Future<Either<DataException, List<CareerModel>>> getCareers() async {
    try {
      final QuerySnapshot querySnapshot = await _db
          .collection(_careersCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return Right(
        querySnapshot.docs
            .map((doc) => CareerModel.fromFirestore(doc))
            .toList(),
      );
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // ========================================================================
  //  Departments
  // ========================================================================

  // Get departments by name
  Future<Either<DataException, List<DepartmentModel>>> getDepartments() async {
    try {
      final QuerySnapshot querySnapshot = await _db
          .collection(_departmentsCollection)
          .orderBy('name')
          .get();

      return Right(
        querySnapshot.docs
            .map((doc) => DepartmentModel.fromFirestore(doc))
            .toList(),
      );
    } on FirebaseException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // ========================================================================
  //  Subjects
  // ========================================================================

  // Get subjects by name
  Future<Either<DataException, List<SubjectModel>>> getSubjects({
    required String id,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await _db
          .collection(_departmentsCollection)
          .doc(id)
          .collection(_subjectsCollection)
          .orderBy("name")
          .get();

      return Right(
        querySnapshot.docs
            .map((doc) => SubjectModel.fromFirestore(doc))
            .toList(),
      );
    } on FirebaseException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // ========================================================================
  //  Files
  // ========================================================================

  // Creates a file document
  Future<Either<DataException, String>> createFileDocument({
    required String userId,
    required String departmentId,
    required String subjectId,
    required DocumentRequestModel data,
  }) async {
    try {
      final DocumentReference ref = _db.collection(_filesCollection).doc();

      final departmentRef = _db
          .collection(_departmentsCollection)
          .doc(departmentId);

      final subjectRef = departmentRef
          .collection(_subjectsCollection)
          .doc(subjectId);

      final parsed = data.copyWith(
        owner: _db.collection(_userCollection).doc(userId),
        department: departmentRef,
        subject: subjectRef,
      );

      await ref.set(parsed.toJsonCreate(id: ref.id));

      return Right("ok");
    } on FirebaseException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Get all files of a subject by name
  Future<Either<DataException, List<DocumentModel>>> getFilesBySubject({
    required String departmentId,
    required String subjectId,
  }) async {
    try {
      final route = _db
          .collection(_departmentsCollection)
          .doc(departmentId)
          .collection(_subjectsCollection)
          .doc(subjectId);

      final QuerySnapshot querySnapshot = await _db
          .collection(_filesCollection)
          .where("subject", isEqualTo: route)
          .orderBy("name")
          .get();

      return Right(
        querySnapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList(),
      );
    } on FirebaseException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }

  // Get all files of a user by name
  Future<Either<DataException, List<DocumentModel>>> getFilesByUser({
    required String userId,
  }) async {
    try {
      final route = _db.collection(_userCollection).doc(userId);

      final QuerySnapshot querySnapshot = await _db
          .collection(_filesCollection)
          .where("owner", isEqualTo: route)
          .orderBy("name")
          .get();

      return Right(
        querySnapshot.docs
            .map((doc) => DocumentModel.fromFirestore(doc))
            .toList(),
      );
    } on FirebaseException catch (e) {
      return Left(DataException(details: e.message));
    } catch (e) {
      return Left(DataException(details: e.toString()));
    }
  }
}
