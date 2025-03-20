import 'package:flutter/material.dart';
import 'doctorcaseanlysis.dart';

class DoctorCasesPage extends StatelessWidget {
  final String doctorId; // Store doctorId

  const DoctorCasesPage({super.key, required this.doctorId}); // Constructor updated

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
          child: ListView.builder(
            itemCount: 5, // Replace with actual case count from DB
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFFF8ED8C),
                child: ListTile(
                  title: Text("Case ${index + 1}"),
                  subtitle: const Text("Click to review"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Case Analysis Page with doctorId and caseId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorCaseAnalysisPage(
                          caseId: index + 1,
                          doctorId: doctorId, // Pass doctorId forward
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
