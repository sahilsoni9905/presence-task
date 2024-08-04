import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:presence/auth/repository/auth_repository.dart';

class OtpAuthScreen extends ConsumerStatefulWidget {
  const OtpAuthScreen(
      {super.key,
      required this.phoneNumber,
      required this.countryCode,
      required this.verificationId});
  final String verificationId;
  final String phoneNumber;
  final String countryCode;

  @override
  ConsumerState<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends ConsumerState<OtpAuthScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _seconds = 40;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
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
        autofocus: index == 0,
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
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
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  void verifyOtp() {
    // this function is not called when i am clicking on verify
    print('reached here for veriftying otp');
    String userOTP =
        _otpControllers.map((controller) => controller.text).join();
    print('reached here for veriftying otp and our otp is $userOTP');
    ref.read(AuthRepositoryProvider).verifyOTP(
        context: context,
        verificationId: widget.verificationId,
        userOTP: userOTP);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.2),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Verification Code',
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Text(
                  'We have sent the verification code to',
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.018,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'your mobile number',
                  style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.018,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '(+${widget.countryCode}) ',
                      style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.018,
                          color: const Color(0xFF008173)),
                    ),
                    Text(
                      '${widget.phoneNumber}  ',
                      style: GoogleFonts.poppins(
                          fontSize: screenHeight * 0.018,
                          color: const Color(0xFF008173)),
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
                  children:
                      List.generate(6, (index) => _buildOtpInputField(index)),
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
                  onPressed: () {
                    verifyOtp();
                  },
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
                    backgroundColor: const Color(0xFF008173),
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
          ],
        ),
      ),
    );
  }
}
