import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class DoctorCaseAnalysisPage extends StatefulWidget {
  final String caseId;
  final String doctorId;

  const DoctorCaseAnalysisPage({
    super.key,
    required this.caseId,
    required this.doctorId,
  });

  @override
  DoctorCaseAnalysisPageState createState() => DoctorCaseAnalysisPageState();
}

class DoctorCaseAnalysisPageState extends State<DoctorCaseAnalysisPage> {
  final TextEditingController _suggestionController = TextEditingController();
  int? selectedDiagnosis; // Track selected diagnosis

  @override
  void initState() {
    super.initState();
    _loadExistingDiagnosis();
  }

  // Helper function to retrieve the document by matching the case_id field.
  Future<DocumentSnapshot?> _getExistingDoc() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctor_diagnosis_suggestions')
          .where('case_id', isEqualTo: widget.caseId.toString())
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        log('No document found for case_id: ${widget.caseId}');
        return null;
      }
    } catch (e) {
      log('Error querying document for case_id ${widget.caseId}: $e');
      return null;
    }
  }

  // Load existing diagnosis for the case using the "case_id" field.
  Future<void> _loadExistingDiagnosis() async {
    DocumentSnapshot? docSnapshot = await _getExistingDoc();
    if (docSnapshot != null && docSnapshot.exists) {
      setState(() {
        selectedDiagnosis = docSnapshot.get('diagnosis_number');
        _suggestionController.text = docSnapshot.get('suggestions') ?? "";
      });
    }
  }

  // Function to update Firestore when selecting a diagnosis.
  // Only updates the document if it exists (matches case_id).
  Future<void> _selectDiagnosis(int diagnosisNumber) async {
    DocumentSnapshot? docSnapshot = await _getExistingDoc();
    if (docSnapshot != null) {
      try {
        await docSnapshot.reference.update({
          'diagnosis_number': diagnosisNumber,
        });
        setState(() {
          selectedDiagnosis = diagnosisNumber;
        });
        log('Diagnosis option $diagnosisNumber updated for Case ${widget.caseId}');
      } catch (e) {
        log('Error updating diagnosis: $e');
      }
    } else {
      log('No existing document found for case ${widget.caseId} to update diagnosis.');
    }
  }

  // Function to submit final diagnosis along with suggestions.
  // Only updates an existing document.
  Future<void> _submitDiagnosis() async {
    if (selectedDiagnosis == null) {
      log('Please select a diagnosis before submitting.');
      return;
    }

    DocumentSnapshot? docSnapshot = await _getExistingDoc();
    if (docSnapshot != null) {
      try {
        await docSnapshot.reference.update({
          'diagnosis_number': selectedDiagnosis,
          'suggestions': _suggestionController.text,
          'status': 'answered',
        });
        log('Diagnosis and suggestions updated for Case ${widget.caseId}');
        Navigator.pop(context);
      } catch (e) {
        log('Error submitting diagnosis: $e');
      }
    } else {
      log('No existing document found for case ${widget.caseId}. Submission aborted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Case #${widget.caseId} Analysis",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1B5E20),
        centerTitle: true,
        elevation: 3,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFFA5D6A7)],
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
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Diagnosis Options",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            _buildDiagnosisButton(context, "Infected with Babesiosis", Colors.red, Icons.warning_amber_rounded, 1),
                            _buildDiagnosisButton(context, "Infected with Anaplasmosis", Colors.orangeAccent, Icons.warning_rounded, 2),
                            _buildDiagnosisButton(context, "Not Infected", Colors.green, Icons.check_circle_outline, 3),
                            _buildDiagnosisButton(context, "Not Clear", Colors.grey, Icons.help_outline, 4),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                              controller: _suggestionController,
                              decoration: InputDecoration(
                                hintText: "Enter your suggestions...",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * 0.8,
                        ),
                        child: ElevatedButton(
                          onPressed: _submitDiagnosis,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: const Text(
                            "Submit Diagnosis",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
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

  Widget _buildDiagnosisButton(BuildContext context, String text, Color color, IconData icon, int diagnosisNumber) {
    return ElevatedButton.icon(
      onPressed: () => _selectDiagnosis(diagnosisNumber),
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDiagnosis == diagnosisNumber ? Colors.black : color,
      ),
    );
  }
}
