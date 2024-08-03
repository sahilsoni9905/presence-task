import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:presence/auth/repository/auth_repository.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isAgreed = false;
  String countryCode = '91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void sendPhoneNumber(String phoneNumber) {
    
    ref
        .read(AuthRepositoryProvider)
        .signInWithPhone(context, phoneNumber , countryCode);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Center(
                child: Image.asset('assets/images/logo.png',
                    height: screenHeight * 0.25),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                'Let\'s get started',
                style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                'Enter your mobile number to proceed',
                style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.02, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintStyle: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {},
                onCountryChanged: (country) {
                  countryCode = country.dialCode;
                  setState(() {});
                },
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (value) {
                      setState(() {
                        _isAgreed = value ?? false;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        'I agree to the ',
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'terms ',
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF008173),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Text(
                        '& ',
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'conditions ',
                        style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.015,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF008173),
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.07,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isAgreed) {
                    sendPhoneNumber(_phoneController.text.trim());
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.015),
                  child: Text(
                    'Send OTP',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: screenHeight * 0.025,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAgreed
                      ? Color(0xFF008173)
                      : Color.fromARGB(255, 126, 127, 127),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
