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
  String? mlDiagnosisResult;
  String? doctorSuggestion;
  bool isReadOnly = false;

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
      final data = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        mlDiagnosisResult = data['ml_result'] ?? "Not Available";
        doctorSuggestion = data['suggestions'] ?? "No suggestions provided.";
        _suggestionController.text = doctorSuggestion!;
        isReadOnly = (data['status'] ?? "").toLowerCase() == "answered";
      });
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  spreadRadius: 2),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 80, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildMLDiagnosisDisplay(),
                        const SizedBox(height: 15),
                        isReadOnly
                            ? _buildReadOnlySuggestion()
                            : _buildEditableSuggestion(),
                        const SizedBox(height: 20),
                        if (!isReadOnly) _buildSubmitButton(),
                        const SizedBox(height: 20), // For extra spacing at bottom
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMLDiagnosisDisplay() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ML Diagnosis Result",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              mlDiagnosisResult ?? "Loading...",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlySuggestion() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Doctor's Suggestions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 10),
            Text(
              doctorSuggestion ?? "No suggestions provided.",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableSuggestion() {
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
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: _suggestionController,
              decoration: InputDecoration(
                hintText: "Enter your suggestions...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
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
      onPressed: () async {
        final docSnapshot = await _getExistingDoc();
        if (docSnapshot != null) {
          try {
            await docSnapshot.reference.update({
              'suggestions': _suggestionController.text,
              'status': 'answered',
            });
            Navigator.pop(context);
          } catch (e) {
            log('Error submitting diagnosis: $e');
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFACD3A8),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: const Text("Submit Diagnosis",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}
