import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? mobileNum ;
  String? verificationID ;

  updatePhoneNum({required String num}) {
    mobileNum = num;
    notifyListeners();
  }

  updateVerificationID({required String verifiID}) {
    verificationID = verifiID;
    notifyListeners();
  }
}
