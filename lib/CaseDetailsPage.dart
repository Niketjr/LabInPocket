import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaseDetailsPage extends StatelessWidget {
  final String farmerName;
  final String caseId;

  const CaseDetailsPage({
    super.key,
    required this.farmerName,
    required this.caseId,
  });

  Future<Map<String, dynamic>> fetchCaseData() async {
    QuerySnapshot caseSnapshot = await FirebaseFirestore.instance
        .collection("doctor_diagnosis_suggestions")
        .where("case_id", isEqualTo: caseId)
        .get();

    if (caseSnapshot.docs.isEmpty) {
      return {};
    }

    var caseData = caseSnapshot.docs.first.data() as Map<String, dynamic>;

    String imageId = caseData["image_id"] ?? "";
    String imageUrl = "";
    if (imageId.isNotEmpty) {
      QuerySnapshot imageSnapshot = await FirebaseFirestore.instance
          .collection("uploaded_image")
          .where("image_id", isEqualTo: imageId)
          .get();
      if (imageSnapshot.docs.isNotEmpty) {
        var imageData = imageSnapshot.docs.first.data() as Map<String, dynamic>;
        imageUrl = imageData["image"] ?? "";
      }
    }

    int diagNum = caseData["diagnosis_number"] ?? 0;
    String diagnosisText = "";
    if (diagNum == 1) {
      diagnosisText = "Infected with Babesiosis";
    } else if (diagNum == 2) {
      diagnosisText = "Infected with Anaplasmosis";
    } else if (diagNum == 3) {
      diagnosisText = "Not Infected";
    } else {
      diagnosisText = "Not Clear";
    }

    String feedbackText = caseData["suggestions"] ?? "";

    return {
      "diagnosis": diagnosisText,
      "feedback": feedbackText,
      "imageUrl": imageUrl,
    };
  }

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
              title: const Text("Case Details", style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchCaseData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Error loading case details"));
                  }

                  final data = snapshot.data!;
                  final String diagnosis = data["diagnosis"] ?? "";
                  final String feedback = data["feedback"] ?? "";
                  final String imageUrl = data["imageUrl"] ?? "";

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _placeholderImage();
                                },
                              )
                                  : _placeholderImage(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSection("Farmer Name", farmerName),
                          _buildSection("Diagnosis", diagnosis),
                          _buildSection("Doctor's Feedback", feedback),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(content, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}