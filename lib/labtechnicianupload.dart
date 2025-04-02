import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Diagnosis.dart'; // Import the Diagnosis page

class LabTechnicianUploadPage extends StatefulWidget {
  final String farmerName;
  final String farmer_id;
  final String labtechId;

  const LabTechnicianUploadPage({
    super.key,
    required this.farmerName,
    required this.farmer_id,
    required this.labtechId,
  });

  @override
  _LabTechnicianUploadPageState createState() => _LabTechnicianUploadPageState();
}

class _LabTechnicianUploadPageState extends State<LabTechnicianUploadPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _cattleNameController = TextEditingController();

  bool _isUploading = false;

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

  // Function to handle image upload process
  Future<void> _uploadImage() async {
    if (_image == null || _cattleNameController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Generate a unique image_id (using timestamp)
      String imageId = DateTime.now().millisecondsSinceEpoch.toString();

      // Simulating the process as image upload is commented out
      // Normally, this is where the image upload to Firebase Storage would happen

      // Save document to Firestore without uploading the image to Firebase Storage
      await FirebaseFirestore.instance.collection('uploaded_image').doc(imageId).set({
        'cattle_name': _cattleNameController.text,
        'farmer_id': widget.farmer_id,
        'image': '',  // Empty string as no image is uploaded
        'image_id': imageId,
      });

      // After the "upload" process, navigate to the Diagnosis page.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosisPage(
            farmerName: widget.farmerName,
            image: _image ?? File(''), farmer_id: widget.farmer_id, labtechId: widget.labtechId, image_id: imageId, // Passing empty file if no image
          ),
        ),
      );
    } catch (e) {
      // Display error if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Upload the blood smear image of ${widget.farmerName}'s cattle",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // TextField to enter the cattle name
                  TextField(
                    controller: _cattleNameController,
                    decoration: InputDecoration(
                      hintText: "Enter Cattle Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
                      Image.file(
                        _image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      const Text("Image selected successfully!",
                          style: TextStyle(color: Colors.white)),
                    ],
                  )
                      : const Text("No image selected", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: (_cattleNameController.text.isNotEmpty && !_isUploading)
                        ? () {
                      // Generate the image_id and upload to Firestore without uploading image
                      String imageId = DateTime.now().millisecondsSinceEpoch.toString();

                      // Simulating the upload process
                      _uploadImage(); // Proceed to upload data

                      // Navigate to the Diagnosis page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiagnosisPage(
                            farmerName: widget.farmerName,
                            image: _image ?? File(''), farmer_id: widget.farmer_id, labtechId: widget.labtechId, image_id: imageId, // Passing empty file if no image
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (_cattleNameController.text.isNotEmpty)
                            ? Colors.orange
                            : Colors.grey),
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Go to Diagnosis",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
