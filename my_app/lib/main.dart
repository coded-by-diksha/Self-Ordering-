import 'package:flutter/material.dart';
import 'package:my_app/pages/homepage.dart';

void main() {
  runApp(SpiceBiteApp());
}

class SpiceBiteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpiceBite',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Placeholder
                Image.asset(
              'assets/logo.png', // Make sure your logo is in the assets folder
              height: 200,       // Adjust the size as needed
            ),


                // Welcome Text
                Text(
                  '"Welcome to SpiceBite"\n Scan. Order. Enjoy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(221, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 10),

                // Instruction Text
                Text(
                  'Scan the QR code on your table to view the menu and order.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),

                // Scan Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the camera page or QR code scanner
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerScreen()),
                );                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 41, 6),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Scan Now',
                    style: TextStyle(color: Color.fromARGB(221, 252, 252, 252)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
