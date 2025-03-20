import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Diagnosis.dart'; // Import the new Diagnosis page

class LabTechnicianUploadPage extends StatefulWidget {
  final String farmerName;

  const LabTechnicianUploadPage({super.key, required this.farmerName});

  @override
  _LabTechnicianUploadPageState createState() => _LabTechnicianUploadPageState();
}

class _LabTechnicianUploadPageState extends State<LabTechnicianUploadPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Capture image from camera
  Future<void> _captureFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Pick image from gallery
  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Navigate to Diagnosis Page
  void _goToDiagnosisPage() {
    if (_image == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosisPage(farmerName: widget.farmerName, image: _image!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload for ${widget.farmerName}"),
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
              children: [
                Text(
                  "Upload the blood smear image of ${widget.farmerName}'s cattle",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _captureFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Capture from Camera"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Upload from Gallery"),
                ),
                const SizedBox(height: 20),

                _image != null
                    ? Column(
                  children: [
                    Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                    const Text("Image selected successfully!", style: TextStyle(color: Colors.white)),
                  ],
                )
                    : const Text("No image selected", style: TextStyle(color: Colors.white)),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _image != null ? _goToDiagnosisPage : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _image != null ? Colors.orange : Colors.grey),
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
