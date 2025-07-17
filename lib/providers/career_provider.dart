/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unetpedia/models/generic/career_model.dart';

class CareerProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'careers';

  // obtener carrera por ID
  // Future<Career?> getCareerById(String id) async {
  //   try {
  //     final DocumentSnapshot doc = await _firestore
  //         .collection(_collection)
  //         .doc(id)
  //         .get();
  //
  //     if (doc.exists) {
  //       return Career.fromFirestore(doc);
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error fetching career by ID: $e');
  //     return null;
  //   }
  // }

  // agregar una carrera
  // Future<bool> addCareer(Career career) async {
  //   try {
  //     await _firestore.collection(_collection).add(career.toFirestore());
  //     return true;
  //   } catch (e) {
  //     print('Error adding career: $e');
  //     return false;
  //   }
  // }

  // actualizar una carrera
  // Future<bool> updateCareer(Career career) async {
  //   try {
  //     await _firestore
  //         .collection(_collection)
  //         .doc(career.id)
  //         .update(career.toFirestore());
  //     return true;
  //   } catch (e) {
  //     print('Error updating career: $e');
  //     return false;
  //   }
  // }

  // Delete a career (isActive false)
  // Future<bool> deleteCareer(String id) async {
  //   try {
  //     await _firestore.collection(_collection).doc(id).update({
  //       'isActive': false,
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     });
  //     return true;
  //   } catch (e) {
  //     print('Error deleting career: $e');
  //     return false;
  //   }
  // }

  // Iniciar carreras con datos de ejemplo
  /*Future<void> initializeCareers() async {
    try {
      // Revisa si ya existen carreras
      final QuerySnapshot existingCareers = await _firestore
          .collection(_collection)
          .limit(1)
          .get();

      if (existingCareers.docs.isNotEmpty) {
        print('Careers already exist, skipping initialization');
        return;
      }

      // Ejemplo de carreras
      final List<Map<String, dynamic>> sampleCareers = [
        {
          'name': 'Arquitectura',
          'description': 'Carrera de diseño arquitectónico y construcción',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería Civil',
          'description': 'Carrera de ingeniería en construcción y infraestructura',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería Electrónica',
          'description': 'Carrera de ingeniería en sistemas electrónicos',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería Ambiental',
          'description': 'Carrera de ingeniería en medio ambiente',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería Informática',
          'description': 'Carrera de ingeniería en sistemas de información',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería Industrial',
          'description': 'Carrera de ingeniería en procesos industriales',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería Mecánica',
          'description': 'Carrera de ingeniería en sistemas mecánicos',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Ingeniería en Producción Animal',
          'description': 'Carrera de ingeniería en producción animal',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Licenciatura en Música',
          'description': 'Carrera de música y artes musicales',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'Psicología',
          'description': 'Carrera de psicología y ciencias del comportamiento',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'TSU en Electromedicina',
          'description': 'Técnico Superior en Electromedicina',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        {
          'name': 'TSU en Entrenamiento Deportivo',
          'description': 'Técnico Superior en Entrenamiento Deportivo',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      ];

      // agregar carreras en lote
      final WriteBatch batch = _firestore.batch();
      for (final careerData in sampleCareers) {
        final DocumentReference docRef = _firestore.collection(_collection).doc();
        batch.set(docRef, careerData);
      }
      
      await batch.commit();
      print('Careers initialized successfully');
    } catch (e) {
      print('Error initializing careers: $e');
    }
  }*/

  // obtener un stream de carreras activas
  // Stream<List<Career>> getCareersStream() {
  //   return _firestore
  //       .collection(_collection)
  //       .where('isActive', isEqualTo: true)
  //       .orderBy('name')
  //       .snapshots()
  //       .map((snapshot) {
  //         return snapshot.docs.map((doc) => Career.fromFirestore(doc)).toList();
  //       });
  // }
}*/
