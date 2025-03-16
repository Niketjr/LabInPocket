import 'package:flutter/material.dart';
import 'labtechnicianupload.dart';

class LabTechnicianHomePage extends StatefulWidget {
  const LabTechnicianHomePage({super.key});

  @override
  _LabTechnicianHomePageState createState() => _LabTechnicianHomePageState();
}

class _LabTechnicianHomePageState extends State<LabTechnicianHomePage> {
  bool showAnswered = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Technician Home"),
        backgroundColor: const Color(0xFF89AC46),
      ),
      body: Column(
        children: [
          // Section Toggle Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAnswered = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: showAnswered ? const Color(0xFF89AC46) : Colors.grey,
                ),
                child: const Text("Answered"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAnswered = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showAnswered ? const Color(0xFF89AC46) : Colors.grey,
                ),
                child: const Text("Unanswered"),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Answered / Unanswered Section
          Expanded(
            child: showAnswered ? _answeredSection() : _unansweredSection(),
          ),
        ],
      ),

      // Floating Button at Bottom Center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FarmerEntryAndImageUploadPage()),
          );
        },
        backgroundColor: const Color(0xFF89AC46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  // Answered Section UI
  Widget _answeredSection() {
    return ListView.builder(
      itemCount: 5, // Replace with real data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            title: Text("Case #$index - Answered"),
            subtitle: const Text("Details about the answered case."),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }

  // Unanswered Section UI
  Widget _unansweredSection() {
    return ListView.builder(
      itemCount: 5, // Replace with real data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            title: Text("Case #$index - Unanswered"),
            subtitle: const Text("Details about the unanswered case."),
            trailing: const Icon(Icons.hourglass_empty, color: Colors.red),
          ),
        );
      },
    );
  }
}
