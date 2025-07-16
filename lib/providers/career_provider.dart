import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unetpedia/models/generic/degrees_response_model.dart';

class CareerProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _careersCollection = "careers";

  // Get all active careers
  Future<List<DegreeResponseModel>> getCareers() async {
    try {
      print("Fetching careers from Firestore...");
      
      // Try simple query first (without ordering to avoid index issues)
      QuerySnapshot querySnapshot;
      try {
        querySnapshot = await _db
            .collection(_careersCollection)
            .where('isActive', isEqualTo: true)
            .orderBy('name')
            .get();
      } catch (e) {
        print("Ordered query failed, trying simple query: $e");
        // Fallback to simple query without ordering
        querySnapshot = await _db
            .collection(_careersCollection)
            .where('isActive', isEqualTo: true)
            .get();
      }
      
      print("Found ${querySnapshot.docs.length} careers");
      
      if (querySnapshot.docs.isEmpty) {
        print("No careers found in Firestore, returning default careers");
        return _getDefaultCareers();
      }
      
      return querySnapshot.docs
          .asMap()
          .entries
          .map((entry) => DegreeResponseModel(
                id: entry.key + 1, // Use index as ID
                name: entry.value['name'] as String,
              ))
          .toList();
    } catch (e) {
      print("Error fetching careers: $e");
      
      // Return some default careers if Firestore fails
      return _getDefaultCareers();
    }
  }

  // Initialize default careers in Firestore
  Future<void> initializeCareers() async {
    try {
      // Check if careers already exist
      final existingCareers = await _db
          .collection(_careersCollection)
          .limit(1)
          .get();
      
      if (existingCareers.docs.isNotEmpty) {
        print("Careers already exist, skipping initialization");
        return;
      }
      
      print("No careers found, attempting to initialize default careers...");
      
      final careers = _getDefaultCareers();
      final batch = _db.batch();
      
      for (final career in careers) {
        if (career.name != null) {
          final docRef = _db.collection(_careersCollection).doc();
          batch.set(docRef, {
            'name': career.name,
            'isActive': true,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      
      await batch.commit();
      print("Default careers initialized successfully");
    } catch (e) {
      print("Error initializing careers: $e");
      // If we can't initialize careers in Firestore, that's okay
      // The getCareers() method will return default careers
    }
  }

  // Get default careers list
  List<DegreeResponseModel> _getDefaultCareers() {
    return [
      DegreeResponseModel(id: 1, name: "Arquitectura"),
      DegreeResponseModel(id: 2, name: "Ingeniería Civil"),
      DegreeResponseModel(id: 3, name: "Ingeniería Electrónica"),
      DegreeResponseModel(id: 4, name: "Ingeniería Ambiental"),
      DegreeResponseModel(id: 5, name: "Ingeniería Informática"),
      DegreeResponseModel(id: 6, name: "Ingeniería Industrial"),
      DegreeResponseModel(id: 7, name: "Ingeniería Mecánica"),
      DegreeResponseModel(id: 8, name: "Ingeniería en Producción Animal"),
      DegreeResponseModel(id: 9, name: "Licenciatura en Música"),
      DegreeResponseModel(id: 10, name: "Psicología"),
      DegreeResponseModel(id: 11, name: "TSU en Electromedicína"),
      DegreeResponseModel(id: 12, name: "TSU en Entrenamiento Deportivo"),
    ];
  }
}