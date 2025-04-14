import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctorcaseanlysis.dart';

class DoctorCasesPage extends StatelessWidget {
  final String doctorId;

  const DoctorCasesPage({super.key, required this.doctorId});

  Future<List<Map<String, dynamic>>> _fetchDoctorCases(String status) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctor_diagnosis_suggestions')
          .where('doctor_id', isEqualTo: doctorId)
          .where('status', isEqualTo: status)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'case_id': doc['case_id'],
          'suggestions': doc['suggestions'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching doctor cases: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Doctor Cases", style: TextStyle(color: Color(0xFF3E3F5B))),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xFF3E3F5B),
            indicatorColor: Color(0xFF3E3F5B),
            tabs: [
              Tab(text: "Pending Cases"),
              Tab(text: "Past Cases"),
            ],
          ),
        ),
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
            child: TabBarView(
              children: [
                _buildCasesList('unanswered'),
                _buildCasesList('answered'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCasesList(String status) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchDoctorCases(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Color(0xFF3E3F5B))));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              status == 'unanswered'
                  ? 'No pending cases for this doctor.'
                  : 'No past cases found.',
              style: const TextStyle(color: Color(0xFF3E3F5B)),
            ),
          );
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
    );
  }
}