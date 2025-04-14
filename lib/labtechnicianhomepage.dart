import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FarmerName.dart';
import 'CaseDetailsPage.dart';

class LabTechnicianHomePage extends StatefulWidget {
  final String labtechId;

  const LabTechnicianHomePage({super.key, required this.labtechId});

  @override
  _LabTechnicianHomePageState createState() => _LabTechnicianHomePageState();
}

class _LabTechnicianHomePageState extends State<LabTechnicianHomePage> {
  bool showAnswered = true;
  List<Map<String, dynamic>> answeredCases = [];
  List<Map<String, dynamic>> unansweredCases = [];

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  Future<void> fetchCases() async {
    try {
      print("LabTech ID received: ${widget.labtechId}");

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("doctor_diagnosis_suggestions")
          .where("labtech_id", isEqualTo: widget.labtechId)
          .get();

      List<Map<String, dynamic>> fetchedAnswered = [];
      List<Map<String, dynamic>> fetchedUnanswered = [];

      Set<String> farmerIds = {};
      List<Map<String, dynamic>> allCases = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String farmerId = data["farmer_id"] ?? "";
        if (farmerId.isNotEmpty) {
          farmerIds.add(farmerId);
        }
        allCases.add(data);
      }

      Map<String, String> farmerNameMap = {};
      if (farmerIds.isNotEmpty) {
        QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
            .collection("farmers")
            .where("farmer_id", whereIn: farmerIds.toList())
            .get();

        for (var doc in farmerSnapshot.docs) {
          var farmerData = doc.data() as Map<String, dynamic>;
          String idKey = farmerData["farmer_id"] ?? "";
          String nameValue = farmerData["name"] ?? "Unknown Farmer";
          if (idKey.isNotEmpty) {
            farmerNameMap[idKey] = nameValue;
          }
        }
      }

      for (var caseData in allCases) {
        String farmerId = caseData["farmer_id"] ?? "";
        caseData["name"] = farmerNameMap[farmerId] ?? "Unknown Farmer";

        if (caseData["status"] == "answered") {
          fetchedAnswered.add(caseData);
        } else {
          fetchedUnanswered.add(caseData);
        }
      }

      setState(() {
        answeredCases = fetchedAnswered;
        unansweredCases = fetchedUnanswered;
      });
    } catch (e) {
      print("Error fetching cases: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1DE), Color(0xFFACD3A8), Color(0xFF8AB2A6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text("Lab Technician Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton("Answered", showAnswered, () {
                    setState(() => showAnswered = true);
                  }),
                  const SizedBox(width: 15),
                  _buildToggleButton("Unanswered", !showAnswered, () {
                    setState(() => showAnswered = false);
                  }),
                ],
              ),
            ),
            Expanded(
              child: showAnswered
                  ? _buildCaseList(answeredCases, "Answered")
                  : _buildCaseList(unansweredCases, "Unanswered"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerNamePage(labtechId: widget.labtechId)));
        },
        backgroundColor: const Color(0xFF8AB2A6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.person_add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFF8AB2A6) : Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 3,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCaseList(List<Map<String, dynamic>> cases, String status) {
    if (cases.isEmpty) {
      return const Center(
        child: Text("No cases available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      itemCount: cases.length,
      itemBuilder: (context, index) {
        return _buildCaseCard(cases[index], status);
      },
    );
  }

  Widget _buildCaseCard(Map<String, dynamic> caseData, String status) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(caseData['name'] ?? "Unknown Farmer", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("Status: $status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(status == "Answered" ? Icons.check_circle : Icons.hourglass_empty, color: status == "Answered" ? Colors.green : Colors.red, size: 30),
        onTap: status == "Answered" ? () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaseDetailsPage(
              farmerName: caseData['name'] ?? "Unknown Farmer", caseId: caseData["case_id"] ?? "None",
            ),
          ),
        ) : null,
      ),
    );
  }
}
