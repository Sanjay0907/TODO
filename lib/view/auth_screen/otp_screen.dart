import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo/constants/commonFunctions.dart';
import 'package:todo/controller/services/auth.dart';
import 'package:todo/utils/colors.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool verifyButtonPressed = false;
  verifyOTP() {
    setState(() {
      verifyButtonPressed = true;
    });
    Auth.verifyOTP(context: context, otp: otpController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonFunctions.blankSpace(
              context: context,
              reqHeight: 0.04,
              reqWidth: 0,
            ),
            Text(
              'Verify Yourself',
              style: textTheme.displayMedium,
            ),
            CommonFunctions.blankSpace(
              context: context,
              reqHeight: 0.02,
              reqWidth: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'To Continue Enter OTP',
                  style: textTheme.displaySmall,
                ),
              ],
            ),
            CommonFunctions.blankSpace(
                context: context, reqHeight: 0.02, reqWidth: 0),
            PinCodeTextField(
              length: 6,
              obscureText: false,
              appContext: context,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              cursorColor: black,
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: white,
                  selectedColor: white,
                  selectedFillColor: white,
                  disabledColor: white,
                  inactiveColor: greyShade300,
                  inactiveFillColor: greyShade300),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: transparent,
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: otpController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {},
              beforeTextPaste: (text) {
                return true;
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => verifyOTP(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width * 0.7, height * 0.06),
              ),
              child: Text(
                'Verify',
                style: textTheme.displayMedium!.copyWith(
                  color: white,
                ),
              ),
            ),
            CommonFunctions.blankSpace(
              context: context,
              reqHeight: 0.05,
              reqWidth: 0,
            ),
          ],
        ),
      ),
    );
  }
}
