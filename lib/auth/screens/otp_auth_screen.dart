import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:presence/auth/repository/auth_repository.dart';

class OtpAuthScreen extends ConsumerStatefulWidget {
  const OtpAuthScreen(
      {super.key, required this.phoneNumber, required this.countryCode , required this.verificationId});
  final String verificationId;
  final String phoneNumber;
  final String countryCode;

  @override
  ConsumerState<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends ConsumerState<OtpAuthScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  Timer? _timer;
  int _seconds = 40;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        setState(() {
          _canResend = true;
          _timer?.cancel();
        });
      }
    });
  }

  void _resendOtp() {
    setState(() {
      _seconds = 40;
      _canResend = false;
      _startTimer();
    });
  }

  Widget _buildOtpInputField(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  void verifyOtp() {
    String userOTP = _otpControllers.map((controller) => controller.text).join();
    ref.read(AuthRepositoryProvider).verifyOTP(
        context: context, verificationId: widget.verificationId, userOTP: userOTP);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification Code',
              style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.03, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Text(
              'We have sent the verification code to',
              style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.018, fontWeight: FontWeight.w400),
            ),
            Text(
              'your mobile number',
              style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.018, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '(+${widget.countryCode}) ',
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.018, color: Color(0xFF008173)),
                ),
                Text(
                  '${widget.phoneNumber}  ',
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.018, color: Color(0xFF008173)),
                ),
                const Icon(
                  Icons.edit,
                  color: Color(0xFF008173),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpInputField(index)),
            ),
            const SizedBox(height: 20),
            Text(
              _seconds > 0
                  ? 'Resend OTP in $_seconds seconds'
                  : 'Didn\'t receive the OTP?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.015),
                child: Text(
                  'Verify',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenHeight * 0.025,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF008173),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 60),
            if (_canResend)
              ElevatedButton(
                onPressed: _resendOtp,
                child: const Text('Resend OTP'),
              ),
          ],
        ),
      ),
    );
  }
}
