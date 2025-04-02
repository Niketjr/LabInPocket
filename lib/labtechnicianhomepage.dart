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

      // Fetch cases from doctor_diagnosis_suggestions matching the labtech_id.
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("doctor_diagnosis_suggestions")
          .where("labtech_id", isEqualTo: widget.labtechId)
          .get();

      List<Map<String, dynamic>> fetchedAnswered = [];
      List<Map<String, dynamic>> fetchedUnanswered = [];

      // Collect all farmer IDs from the fetched cases.
      // Here we assume that the field in each case document that holds the farmer's ID is "farmer_id".
      Set<String> farmerIds = {};
      List<Map<String, dynamic>> allCases = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String farmerId = data["farmer_id"] ?? "";
        String caseId = data["case_id"];
        if (farmerId.isNotEmpty) {
          farmerIds.add(farmerId);
        }
        allCases.add(data);
      }

      // Fetch all corresponding farmer documents in a single query.
      Map<String, String> farmerNameMap = {};
      if (farmerIds.isNotEmpty) {
        QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
            .collection("farmers")
        // Here we assume that the unique ID in the farmers collection is stored in the "id" field.
            .where("farmer_id", whereIn: farmerIds.toList())
            .get();

        for (var doc in farmerSnapshot.docs) {
          var farmerData = doc.data() as Map<String, dynamic>;
          // Map the farmer's "id" to his/her "name".
          String idKey = farmerData["farmer_id"] ?? "";
          String nameValue = farmerData["name"] ?? "Unknown Farmer";
          if (idKey.isNotEmpty) {
            farmerNameMap[idKey] = nameValue;
          }
        }
      }

      // Assign the correct farmer name to each case based on the matching farmer document.
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
        print("Answered Cases: $answeredCases");
        print("Unanswered Cases: $unansweredCases");
      });
    } catch (e) {
      print("Error fetching cases: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Lab Technician Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF89AC46),
        elevation: 5,
      ),
      body: Column(
        children: [
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
                ? _buildCaseList(answeredCases, Colors.green, "Answered")
                : _buildCaseList(unansweredCases, Colors.red, "Unanswered"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerNamePage(labtechId: widget.labtechId)));
        },
        backgroundColor: const Color(0xFF89AC46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.person_add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFF89AC46) : Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCaseList(List<Map<String, dynamic>> cases, Color iconColor, String status) {
    if (cases.isEmpty) {
      return const Center(
        child: Text("No cases available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      itemCount: cases.length,
      itemBuilder: (context, index) {
        return _buildCaseCard(cases[index], iconColor, status);
      },
    );
  }

  Widget _buildCaseCard(Map<String, dynamic> caseData, Color iconColor, String status) {
    return GestureDetector(
      onTap: () {
        if (status == "Answered") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaseDetailsPage(
                farmerName: caseData['name'] ?? "Unknown Farmer", caseId: caseData["case_id"] ?? "None" ,
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(caseData['image_path'] ?? 'assets/cow.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseData['name'] ?? "Unknown Farmer",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Status: $status",
                      style: TextStyle(fontSize: 16, color: iconColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Icon(
                status == "Answered" ? Icons.check_circle : Icons.hourglass_empty,
                color: status == "Answered" ? Colors.green : iconColor,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
