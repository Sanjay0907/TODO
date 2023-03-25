// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:todo/constants/commonFunctions.dart';
import 'package:todo/controller/provider/auth_provider.dart';
import 'package:todo/controller/services/auth.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/view/auth_screen/otp_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool submitButtonPressed = false;

  onSubmit() async {
    setState(() {
      submitButtonPressed = true;
    });

    context
        .read<AuthProvider>()
        .updatePhoneNum(num: '+91${phoneNumberController.text.trim()}');

    await Auth.getOTP(
      context: context,
    );

    context.read<AuthProvider>().verificationID!.isNotEmpty
        ? Navigator.push(
            context,
            PageTransition(
              child: const OTPScreen(),
              type: PageTransitionType.rightToLeft,
            ),
          )
        : log('Verification Code not found');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        submitButtonPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFunctions.blankSpace(
                context: context,
                reqHeight: 0.1,
                reqWidth: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TODO',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.25,
                    width: height * 0.25,
                    margin: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: Image(
                      image: AssetImage(
                        'assets/images/sign_in_screen.png',
                      ),
                    ),
                  ),
                ],
              ),
              CommonFunctions.blankSpace(
                context: context,
                reqHeight: 0.02,
                reqWidth: 0,
              ),
              Text(
                'Enter your Mobile Number',
                style: textTheme.displaySmall,
              ),
              CommonFunctions.blankSpace(
                context: context,
                reqHeight: 0.02,
                reqWidth: 0,
              ),
              TextField(
                controller: phoneNumberController,
                cursorColor: white,
                cursorHeight: 22,
                style: textTheme.displaySmall,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: white,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greyShade300, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: greyShade300, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: greyShade300, width: 1),
                  ),
                  // prefixIconConstraints: BoxConstraints(maxWidth: width * 0.2),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(right: width * 0.05),
                    child: Container(
                      width: width * 0.18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border:
                              Border(right: BorderSide(color: greyShade300))),
                      child: Text(
                        '+91',
                        style: textTheme.displaySmall,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: buttonGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                        onPressed: () async => onSubmit(),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(width * 0.7, height * 0.08),
                            backgroundColor: transparent),
                        child: Builder(builder: (context) {
                          if (submitButtonPressed == true) {
                            return const CircularProgressIndicator(
                              color: white,
                            );
                          }
                          return Text(
                            'Proceed',
                            style:
                                textTheme.displayMedium!.copyWith(color: white),
                          );
                        })),
                  ),
                ],
              ),
              CommonFunctions.blankSpace(
                context: context,
                reqHeight: 0.1,
                reqWidth: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
