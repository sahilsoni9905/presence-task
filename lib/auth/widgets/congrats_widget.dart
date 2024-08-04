import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratsWidget extends StatelessWidget {
  const CongratsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Dialog(
        child: Container(
          height: screenHeight * 0.4,
          width: screenWidth * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/congrats.png.png', 
                height: screenHeight * 0.4 * 0.4,
              ),
              Text('Account Created',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 20,
              ),
              Text('Your accont has been created',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400)),
              Text('successfully!',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                ),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
