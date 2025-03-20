import 'package:flutter/material.dart';
import 'FarmerName.dart';
import 'CaseDetailsPage.dart';

class LabTechnicianHomePage extends StatefulWidget {
  final Map<String, String>? newCase;

  const LabTechnicianHomePage({super.key, this.newCase});


  @override
  _LabTechnicianHomePageState createState() => _LabTechnicianHomePageState();
}

class _LabTechnicianHomePageState extends State<LabTechnicianHomePage> {
  bool showAnswered = true;

  List<Map<String, String>> unansweredCases = [];
  List<Map<String, String>> answeredCases = [
    {
      "farmerName": "John Doe",
      "imagePath": "assets/sample1.png",
      "diagnosis": "Infected with Babesiosis",
      "feedback": "Administer prescribed medication and monitor for 2 weeks."
    },
    {
      "farmerName": "Jane Smith",
      "imagePath": "assets/sample2.png",
      "diagnosis": "Not Infected",
      "feedback": "No infection detected. Maintain hygiene and monitor symptoms."
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.newCase != null) {
      setState(() {
        unansweredCases.add(widget.newCase!);
      });
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
                  setState(() {
                    showAnswered = true;
                  });
                }),
                const SizedBox(width: 15),
                _buildToggleButton("Unanswered", !showAnswered, () {
                  setState(() {
                    showAnswered = false;
                  });
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerNamePage()));
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

  Widget _buildCaseList(List<Map<String, String>> cases, Color iconColor, String status) {
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

  Widget _buildCaseCard(Map<String, String> caseData, Color iconColor, String status) {
    return GestureDetector(
      onTap: () {
        if (status == "Answered") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaseDetailsPage(
                farmerName: caseData['farmerName'] ?? "Unknown Farmer",
                imagePath: caseData['imagePath'] ?? "assets/cow.png",
                diagnosis: caseData['diagnosis'] ?? "No diagnosis available",
                feedback: caseData['feedback'] ?? "No feedback received",
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
                    image: AssetImage(caseData['imagePath'] ?? 'assets/cow.png'),
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
                      caseData['farmerName'] ?? "Unknown Farmer",
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
