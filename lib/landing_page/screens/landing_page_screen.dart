import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/auth/screens/phone_auth_screen.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  void initState() {
    super.initState();

    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneAuthScreen()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF00534A),
                Color(0xFF008173),
                Color(0xFFD4F7C2),
              ],
              begin: Alignment.centerRight,
              end: Alignment.bottomLeft,
              stops: [0, 0.44, 1]),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: screenHeight * 0.25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    'Lead Fusion',
                    style: GoogleFonts.poppins(
                        color: Color(0xFFD4F7C2),
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Positioned(
              child: Image.asset(
                'assets/images/Dots.png',
                height: screenHeight * 0.45,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



