import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///////////////////////////////////////////// Add Lab Technician ///////////////////////////////////////////
  Future<void> addLabTechnician() async {
    try {
      await _firestore.collection('lab_technicians').add({
        'labtech_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'John Doe',
        'login': 'johndoe',
        'password': 'password123',
      });
      print('Lab Technician added successfully');
    } catch (e) {
      print('Error adding Lab Technician: $e');
    }
  }

  ///////////////////////////////////////////// Add Doctor ///////////////////////////////////////////
  Future<void> addDoctor() async {
    try {
      await _firestore.collection('doctors').add({
        'doctor_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'Dr. Smith',
        'login': 'drsmith',
        'password': 'docpass456',
      });
      print('Doctor added successfully');
    } catch (e) {
      print('Error adding Doctor: $e');
    }
  }

  ///////////////////////////////////////////// Add Farmer ///////////////////////////////////////////
  Future<void> addFarmer() async {
    try {
      await _firestore.collection('farmers').add({
        'farmer_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': 'Farmer Joe',
      });
      print('Farmer added successfully');
    } catch (e) {
      print('Error adding Farmer: $e');
    }
  }

  ///////////////////////////////////////////// Upload Image ///////////////////////////////////////////
  Future<void> uploadImage() async {
    try {
      await _firestore.collection('uploaded_images').add({
        'farmer_id': '123456',
        'image_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'cattle_name': 'Brown Cow',
        'image': 'https://example.com/cow_image.jpg',
      });
      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading Image: $e');
    }
  }

  ///////////////////////////////////////////// Add Doctor Diagnosis Suggestion ///////////////////////////////////////////
  Future<void> addDoctorDiagnosisSuggestion() async {
    try {
      await _firestore.collection('doctor_diagnosis_suggestions').add({

        'labtech_id': '1742492332789',
        'doctor_id': 'doc901',
        'case_id': 'case003',

        'status': 'unanswered',
        'diagnosis_number': 1,
        'suggestions': 'The cattle might have an infection.',
      });
      print('Doctor Diagnosis Suggestion added successfully');
    } catch (e) {
      print('Error adding Doctor Diagnosis Suggestion: $e');
    }
  }
}
