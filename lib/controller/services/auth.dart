// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/provider/auth_provider.dart';
import 'package:todo/view/auth_screen/otp_screen.dart';
import 'package:todo/view/auth_screen/sign_in_logic.dart';

class Auth {
  static bool checkAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      log('User is Authenticated');
      return true;
    }
    log('User not Authenticated');
    return false;
  }

  static Future getOTP({
    // required String phoneNumber,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String phoneNumber = context.read<AuthProvider>().mobileNum!;
    log('fetched Phone Number is');
    log(phoneNumber);
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credentials) {
          log(credentials.toString());
        },
        verificationFailed: (FirebaseAuthException e) {
          log(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          log(verificationId);
          context
              .read<AuthProvider>()
              .updateVerificationID(verifiID: verificationId);

          Navigator.push(
              context,
              PageTransition(
                child: const OTPScreen(),
                type: PageTransitionType.rightToLeft,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log(e.toString());
    }
  }

  static Future verifyOTP(
      {required BuildContext context, required String otp}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    log('start');

    log('end');
    String verificationID = context.read<AuthProvider>().verificationID!;
    log('fetched verification id is \n ');
    log(verificationID);
    try {
      log('fetched verification id is \n $verificationID');
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: otp);
      await auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const SignInLogic(),
              type: PageTransitionType.scale,
              alignment: Alignment.center),
          (route) => false);
    } catch (e) {
      log(e.toString());
    }
  }
}
