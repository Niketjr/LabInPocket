import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'doctorlogin.dart';

class DoctorRegistrationPage extends StatefulWidget {
  const DoctorRegistrationPage({super.key});

  @override
  _DoctorRegistrationPageState createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _registerDoctor() async {
    String login = _loginController.text.trim();
    String name = _nameController.text.trim();
    String password = _passwordController.text.trim();

    if (login.isEmpty || name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    String doctorId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await _firestore.collection("doctors").doc(doctorId).set({
        "doctor_id": doctorId,
        "login": login,
        "name": name,
        "password": password,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DoctorLoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Doctor Registration", style: TextStyle(color: Color(0xFF3E3F5B))),
      //   backgroundColor: const Color(0xFF8AB2A6),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF6F1DE), Color(0xFFACD3A8), Color(0xFF8AB2A6)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register as a Doctor",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E3F5B),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(_loginController, "Enter Login ID"),
                const SizedBox(height: 20),
                _buildTextField(_nameController, "Enter Name"),
                const SizedBox(height: 20),
                _buildTextField(_passwordController, "Enter Password", obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerDoctor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFACD3A8),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Register", style: TextStyle(fontSize: 18, color: Color(0xFF3E3F5B))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
