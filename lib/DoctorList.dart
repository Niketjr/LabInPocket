import 'package:flutter/material.dart';
import 'dart:io';
import 'labtechnicianhomepage.dart';

class DoctorListPage extends StatelessWidget {
  final String farmerName;
  final File image;

  DoctorListPage({super.key, required this.farmerName, required this.image});

  final List<Map<String, String>> doctors = [
    {"name": "Dr. Rajesh Kumar", "specialty": "Veterinary Specialist", "image": "assets/doctor1.jpg"},
    {"name": "Dr. Meera Kapoor", "specialty": "Animal Pathologist", "image": "assets/doctor2.jpg"},
    {"name": "Dr. Arjun Sharma", "specialty": "Cattle Disease Expert", "image": "assets/doctor3.jpg"},
    {"name": "Dr. Priya Nair", "specialty": "Livestock Health Consultant", "image": "assets/doctor4.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Doctor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return _doctorCard(context, doctors[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _doctorCard(BuildContext context, Map<String, String> doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LabTechnicianHomePage(
              newCase: {"farmerName": farmerName, "imagePath": "assets/cow.png"},
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: CircleAvatar(radius: 30, backgroundImage: AssetImage(doctor["image"]!)),
          title: Text(doctor["name"]!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text(doctor["specialty"]!, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
      ),
    );
  }
}
