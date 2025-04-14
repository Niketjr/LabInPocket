import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'labtechnicianhomepage.dart';
import 'dart:io';

class DoctorListPage extends StatelessWidget {
  final String farmerName;
  final String farmer_id;
  final String labtechId;
  final String image_id;
  final File image;

  const DoctorListPage({
    super.key,
    required this.farmerName,
    required this.image,
    required this.farmer_id,
    required this.labtechId,
    required this.image_id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1DE), Color(0xFFACD3A8), Color(0xFF8AB2A6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(
                "Select a Doctor for ${farmerName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('doctors').get(),
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
                        final doctorName = doctor['name'];
                        final doctorId = doctor['doctor_id'];

                        return _doctorCard(context, doctorName, doctorId);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _doctorCard(BuildContext context, String doctorName, String doctorId) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        title: Text(
          doctorName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: () async {
          String caseId = "case${DateTime.now().millisecondsSinceEpoch}";
          int diagnosisNumber = DateTime.now().millisecondsSinceEpoch % 100000;

          await FirebaseFirestore.instance.collection('doctor_diagnosis_suggestions').add({
            'case_id': caseId,
            'diagnosis_number': diagnosisNumber,
            'doctor_id': doctorId,
            'farmer_id': farmer_id,
            'labtech_id': labtechId,
            'status': 'unanswered',
            'suggestions': '',
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LabTechnicianHomePage(labtechId: labtechId),
            ),
          );
        },
      ),
    );
  }
}