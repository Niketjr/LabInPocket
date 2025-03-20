import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctorcases.dart';
import 'doctorregistration.dart';

class DoctorLoginPage extends StatefulWidget {
  const DoctorLoginPage({super.key});

  @override
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _login() async {
    String login = _loginController.text.trim();
    String password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("doctors")
          .where("login", isEqualTo: login)
          .where("password", isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doctorData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String doctorId = doctorData["doctor_id"];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DoctorCasesPage(doctorId: doctorId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DoctorRegistrationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Login"),
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
                const Text(
                  "Doctor Login",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    hintText: "Enter Login ID",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF89AC46),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: _navigateToRegister,
                  child: const Text("New user? Register", style: TextStyle(fontSize: 16, color: Colors.white, decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
