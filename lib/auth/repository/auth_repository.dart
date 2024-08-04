import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presence/auth/screens/otp_auth_screen.dart';
import 'package:presence/auth/screens/user_info_screen.dart';

final AuthRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;

  AuthRepository({
    required this.auth,
  });

  void signInWithPhone(
      BuildContext context, String phoneNumber, String countryCode) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+$countryCode$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpAuthScreen(
                      phoneNumber: phoneNumber,
                      countryCode: countryCode,
                      verificationId: verificationId,
                    )),
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint('something went wrong');
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      print(userOTP);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserInfoScreen()),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('some error occured ' + e.toString());
    }
  }
}
