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
    // Fetch case data from doctor_diagnosis_suggestions collection using caseId.
    QuerySnapshot caseSnapshot = await FirebaseFirestore.instance
        .collection("doctor_diagnosis_suggestions")
        .where("case_id", isEqualTo: caseId)
        .get();

    if (caseSnapshot.docs.isEmpty) {
      print("No matching case found for caseId: $caseId");
      return {};
    }

    var caseData = caseSnapshot.docs.first.data() as Map<String, dynamic>;
    print("Fetched case data: $caseData");

    // Retrieve image_id and fetch the corresponding image URL.
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
        print("Fetched image URL: $imageUrl for imageId: $imageId");
      } else {
        print("No matching uploaded image found for image_id: $imageId");
      }
    } else {
      print("No image_id found in case data for caseId: $caseId");
    }

    // Determine diagnosis text from diagnosis_number.
    int diagNum = caseData["diagnosis_number"] ?? 0;
    String diagnosisText = "";
    if (diagNum == 1) {
      diagnosisText = "Infected with babesiosis";
    } else if (diagNum == 2) {
      diagnosisText = "Infected with Anaplasmosis";
    } else if (diagNum == 3) {
      diagnosisText = "Not Infected";
    } else if (diagNum == 4) {
      diagnosisText = "Not clear";
    } else {
      diagnosisText = "Not Clear";
    }
    print("Diagnosis number: $diagNum, Diagnosis text: $diagnosisText");

    // Get doctor's feedback from suggestions.
    String feedbackText = caseData["suggestions"] ?? "";
    print("Doctor's feedback: $feedbackText");

    return {
      "diagnosis": diagnosisText,
      "feedback": feedbackText,
      "imageUrl": imageUrl,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Case Details"),
        backgroundColor: const Color(0xFF89AC46),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCaseData(),
        builder: (context, snapshot) {
          // While waiting for data, show a loading indicator.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If an error occurs or no data is found.
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Error loading case details"));
          }
          // Data fetched successfully.
          final data = snapshot.data!;
          final String diagnosis = data["diagnosis"] ?? "";
          final String feedback = data["feedback"] ?? "";
          final String imageUrl = data["imageUrl"] ?? "";

          return SingleChildScrollView( // ✅ Fix for text overflow
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Safe Image Handling
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
                          print("Error loading network image: $error");
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      )
                          : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Farmer Name
                  Text(
                    "Farmer: $farmerName",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // ✅ Diagnosis Section
                  _buildSection("Diagnosis", diagnosis),

                  // ✅ Feedback Section
                  _buildSection("Doctor's Feedback", feedback),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ Section Builder (Reusable)
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
            color: Colors.grey[100],
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
