import 'package:flutter/material.dart';

class DoctorCaseAnalysisPage extends StatelessWidget {
  final int caseId;

  const DoctorCaseAnalysisPage({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Case #$caseId Analysis",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1B5E20), // Dark green for professionalism
        centerTitle: true,
        elevation: 3,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFFA5D6A7)], // Professional green gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image placeholder
                    Center(
                      child: Container(
                        height: 170,
                        width: constraints.maxWidth * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Diagnosis Section
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // Centered content
                          children: [
                            const Text(
                              "Diagnosis Options",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 10),

                            // Diagnosis Buttons
                            _buildDiagnosisButton(context, "Infected with Babesiosis", Colors.red, Icons.warning_amber_rounded),
                            _buildDiagnosisButton(context, "Infected with Anaplasmosis", Colors.orangeAccent, Icons.warning_rounded),
                            _buildDiagnosisButton(context, "Not Infected", Colors.green, Icons.check_circle_outline),
                            _buildDiagnosisButton(context, "Not Clear", Colors.grey, Icons.help_outline),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Additional Suggestions
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Additional Suggestions",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Enter your suggestions...",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              maxLines: 2, // Smaller text field
                            ),
                            const SizedBox(height: 12),

                            // Submit Feedback Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle feedback submission
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent, // Blue for differentiation
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  elevation: 5,
                                ),
                                child: const Text("Submit Feedback", style: TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Main Submit Button
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * 0.8, // Ensures button stays within screen
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Store diagnosis and suggestions in DB
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20), // Dark green
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: const Text("Submit Diagnosis", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Diagnosis Button (Compact)
  Widget _buildDiagnosisButton(BuildContext context, String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300), // Limits button width
        child: ElevatedButton.icon(
          onPressed: () {
            // Handle selection logic
          },
          icon: Icon(icon, color: Colors.white, size: 22),
          label: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14), // Adjusted padding
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}
