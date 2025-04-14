import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'doctorlist.dart';

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

  Future<void> _captureFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _cattleNameController.text.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String imageId = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance.collection('uploaded_image').doc(imageId).set({
        'cattle_name': _cattleNameController.text,
        'farmer_id': widget.farmer_id,
        'image': '',
        'image_id': imageId,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorListPage(
            farmerName: widget.farmerName,
            image: _image!,
            farmer_id: widget.farmer_id,
            labtechId: widget.labtechId,
            image_id: imageId,
          ),
        ),
      );
    } catch (e) {
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
              title: Text(
                "Upload for ${widget.farmerName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Upload the blood smear image of ${widget.farmerName}'s cattle",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _cattleNameController,
                          textAlign: TextAlign.center,
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
                                style: TextStyle(color: Colors.black)),
                          ],
                        )
                            : const Text("No image selected", style: TextStyle(color: Colors.black)),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: (!_isUploading) ? _uploadImage : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: _isUploading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Upload Image",
                              style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
