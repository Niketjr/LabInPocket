import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctorcaseanlysis.dart';

class DoctorCasesPage extends StatelessWidget {
  final String doctorId;

  const DoctorCasesPage({super.key, required this.doctorId});

  Future<List<Map<String, dynamic>>> _fetchDoctorCases() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctor_diagnosis_suggestions')
          .where('doctor_id', isEqualTo: doctorId)
          .where('status', isEqualTo: 'unanswered')
          .get();

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF6F1DE), Color(0xFFACD3A8), Color(0xFF8AB2A6)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Pending Cases",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E3F5B),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchDoctorCases(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Color(0xFF3E3F5B))));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No cases available for this doctor.', style: TextStyle(color: Color(0xFF3E3F5B))));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var caseData = snapshot.data![index];
                        String caseId = caseData['case_id'].toString();

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text("Case $caseId", style: const TextStyle(color: Color(0xFF3E3F5B))),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF3E3F5B)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorCaseAnalysisPage(
                                    caseId: caseId,
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
            ],
          ),
        ),
      ),
    );
  }
}
