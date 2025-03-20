import 'package:flutter/material.dart';
import 'doctorlogin.dart';
import 'labtechnicianlogin.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89AC46), Color(0xFFD3E671)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Lab in Pocket',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Text(
                  'Are you a Doctor?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(context, 'Yes', Colors.green, Colors.white, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorLoginPage()),
                      );
                    }),
                    SizedBox(width: 20),
                    _buildButton(context, 'No', Colors.redAccent, Colors.white, () {
                      // Navigate to Lab technician Login
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LabTechnicianLogin()),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}