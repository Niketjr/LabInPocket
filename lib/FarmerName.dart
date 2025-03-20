import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'labtechnicianupload.dart'; // Ensure correct import

class FarmerNamePage extends StatefulWidget {
  const FarmerNamePage({super.key});

  @override
  _FarmerNamePageState createState() => _FarmerNamePageState();
}

class _FarmerNamePageState extends State<FarmerNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addFarmerAndNavigate() async {
    String farmerName = _nameController.text.trim();

    if (farmerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the farmer's name"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create a unique farmer ID
      String farmerId = DateTime.now().millisecondsSinceEpoch.toString();

      // Add farmer details to Firestore
      await _firestore.collection('farmers').add({
        'farmer_id': farmerId,
        'name': farmerName,
      });

      print('Farmer added successfully');

      // Navigate to next page after successful addition
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LabTechnicianUploadPage(farmerName: farmerName),
        ),
      );
    } catch (e) {
      print('Error adding Farmer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error adding farmer: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Farmer's Name"),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Enter Farmer's Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Farmer Name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _addFarmerAndNavigate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF89AC46),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
