import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for upload functionality
import 'labtechnicianhomepage.dart';

class DoctorListPage extends StatelessWidget {
  final String farmerName;
  final String farmer_id;
  final String labtechId;
  final String image_id;
  final File image;

  DoctorListPage({super.key, required this.farmerName, required this.image, required this.farmer_id, required this.labtechId, required this.image_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Doctor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('doctors').get(), // Fetch doctors data from the Firestore collection
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error fetching doctor data"));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No doctors found"));
              }

              final doctors = snapshot.data!.docs;

              return ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  final doctorName = doctor['name']; // Assuming the Firestore document has a 'name' field for the doctor
                  final doctorId = doctor['doctor_id']; // Assuming the Firestore document ID is used as the doctor_id

                  return _doctorCard(context, doctorName, doctorId);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _doctorCard(BuildContext context, String doctorName, String doctorId) {
    return GestureDetector(
      onTap: () async {
        // Generate a random case ID (using the current milliseconds timestamp)
        String caseId = "case${DateTime.now().millisecondsSinceEpoch}"; // Random case ID
        int diagnosisNumber = DateTime.now().millisecondsSinceEpoch % 100000; // Random diagnosis number

        // Prepare the data to upload to Firestore
        await FirebaseFirestore.instance.collection('doctor_diagnosis_suggestions').add({
          'case_id': caseId,
          'diagnosis_number': diagnosisNumber,
          'doctor_id': doctorId,  // Upload the selected doctor's id
          'farmer_id': farmer_id, // Upload the passed farmer_id
          'labtech_id': labtechId, // Upload the passed labtechId
          'status': 'unanswered',   // Default status
          'suggestions': '',       // Default suggestions
        });

        // Navigate to the next page (LabTechnicianHomePage)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LabTechnicianHomePage(labtechId: labtechId), // Pass labtechId
          ),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          title: Text(doctorName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
      ),
    );
  }
}
