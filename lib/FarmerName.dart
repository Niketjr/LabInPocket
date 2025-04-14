import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'labtechnicianupload.dart';

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
        String farmerId = DateTime.now().millisecondsSinceEpoch.toString();

        await _firestore.collection("farmers").doc(farmerId).set({
          'farmer_id': farmerId,
          'name': _nameController.text,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LabTechnicianUploadPage(
              farmerName: _nameController.text,
              farmer_id: farmerId,
              labtechId: widget.labtechId,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("An error occurred. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        title: const Text("Farmer Name", style: TextStyle(color: Color(0xFF3E3F5B))),
        backgroundColor: const Color(0xFF8AB2A6),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1DE), Color(0xFFACD3A8), Color(0xFF8AB2A6)],
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E3F5B)),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Farmer Name",
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _navigateToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8AB2A6),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E3F5B))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}