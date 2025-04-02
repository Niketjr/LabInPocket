import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctorcaseanlysis.dart';

class DoctorCasesPage extends StatelessWidget {
  final String doctorId; // Store doctorId

  const DoctorCasesPage({super.key, required this.doctorId}); // Constructor updated

  Future<List<Map<String, dynamic>>> _fetchDoctorCases() async {
    try {
      // Query Firestore to fetch cases for the specific doctor that are 'unanswered'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctor_diagnosis_suggestions')
          .where('doctor_id', isEqualTo: doctorId)
          .where('status', isEqualTo: 'unanswered') // Only fetch unanswered cases
          .get();

      // Extract data from the snapshot and return it as a list of maps
      List<Map<String, dynamic>> cases = snapshot.docs.map((doc) {
        return {
          'case_id': doc['case_id'],
          'suggestions': doc['suggestions'],
        };
      }).toList();

      return cases;
    } catch (e) {
      print('Error fetching doctor cases: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Cases"),
        backgroundColor: const Color(0xFF89AC46),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89AC46), Color(0xFFD3E671)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchDoctorCases(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No cases available for this doctor.'));
              }

              // Display the fetched doctor-specific cases
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var caseData = snapshot.data![index];

                  // // Extract numeric part of the case_id, assuming 'case' prefix
                  // String caseIdString = caseData['case_id'].replaceAll(RegExp(r'[^0-9]'), '');

                  // Convert caseId to int
                  String caseId = caseData['case_id'].toString();

                  return Card(
                    color: const Color(0xFFF8ED8C),
                    child: ListTile(
                      title: Text("Case $caseId"), // Display only the case number
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to Case Analysis Page with doctorId and caseId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorCaseAnalysisPage(
                              caseId: caseId, // Now correctly passed as String
                              doctorId: doctorId,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
