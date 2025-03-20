import 'package:flutter/material.dart';

class CaseDetailsPage extends StatelessWidget {
  final String farmerName;
  final String imagePath;
  final String diagnosis;
  final String feedback;

  const CaseDetailsPage({
    super.key,
    required this.farmerName,
    required this.imagePath,
    required this.diagnosis,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Case Details"),
        backgroundColor: const Color(0xFF89AC46),
      ),
      body: SingleChildScrollView( // ✅ Fix for text overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Safe Image Handling
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
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
