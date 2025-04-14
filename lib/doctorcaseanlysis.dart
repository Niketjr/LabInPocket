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
  int? selectedDiagnosis;

  @override
  void initState() {
    super.initState();
    _loadExistingDiagnosis();
  }

  Future<DocumentSnapshot?> _getExistingDoc() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctor_diagnosis_suggestions')
          .where('case_id', isEqualTo: widget.caseId.toString())
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      return null;
    } catch (e) {
      log('Error querying document: $e');
      return null;
    }
  }

  Future<void> _loadExistingDiagnosis() async {
    DocumentSnapshot? docSnapshot = await _getExistingDoc();
    if (docSnapshot != null && docSnapshot.exists) {
      setState(() {
        selectedDiagnosis = docSnapshot.get('diagnosis_number');
        _suggestionController.text = docSnapshot.get('suggestions') ?? "";
      });
    }
  }

  Future<void> _selectDiagnosis(int diagnosisNumber) async {
    DocumentSnapshot? docSnapshot = await _getExistingDoc();
    if (docSnapshot != null) {
      try {
        await docSnapshot.reference.update({'diagnosis_number': diagnosisNumber});
        setState(() {
          selectedDiagnosis = diagnosisNumber;
        });
      } catch (e) {
        log('Error updating diagnosis: $e');
      }
    }
  }

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
        Navigator.pop(context);
      } catch (e) {
        log('Error submitting diagnosis: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case #${widget.caseId} Analysis",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color(0xFF8AB2A6),
        centerTitle: true,
        elevation: 3,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1DE), Color(0xFFACD3A8), Color(0xFF8AB2A6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: double.infinity,
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
                const SizedBox(height: 15),
                _buildDiagnosisOptions(context),
                const SizedBox(height: 15),
                _buildSuggestionInput(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosisOptions(BuildContext context) {
    return Card(
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
    );
  }

  Widget _buildDiagnosisButton(BuildContext context, String text, Color color, IconData icon, int diagnosisNumber) {
    return ElevatedButton.icon(
      onPressed: () => _selectDiagnosis(diagnosisNumber),
      icon: Icon(icon, color: Colors.white),
      label: Text(text,style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDiagnosis == diagnosisNumber ? Colors.black : color,
      ),
    );
  }

  Widget _buildSuggestionInput() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Additional Suggestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
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
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitDiagnosis,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFACD3A8),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: const Text("Submit Diagnosis", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}
