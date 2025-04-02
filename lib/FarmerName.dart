import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'labtechnicianupload.dart'; // Ensure correct import

class FarmerNamePage extends StatefulWidget {
  final String labtechId;
  const FarmerNamePage({super.key, required this.labtechId});

  @override
  _FarmerNamePageState createState() => _FarmerNamePageState();
}

class _FarmerNamePageState extends State<FarmerNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> _navigateToNextPage() async {
    if (_nameController.text.isNotEmpty) {
      try {
        // Generate a unique farmer_id using the current timestamp.
        String farmerId = DateTime.now().millisecondsSinceEpoch.toString();

        // Upload the farmer name to the "farmers" collection.
        await FirebaseFirestore.instance.collection("farmers").doc(farmerId).set({
          'farmer_id': farmerId,
          'name': _nameController.text,
        });

        // After successful upload, navigate to the next page.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LabTechnicianUploadPage(farmerName: _nameController.text, farmer_id: farmerId, labtechId: widget.labtechId,),
          ),
        );
      } catch (e) {
        // Display an error if upload fails.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter a farmer name"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show error message if input is empty.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a farmer name"),
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
                  onPressed: _navigateToNextPage,  // ✅ Correct function name
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
