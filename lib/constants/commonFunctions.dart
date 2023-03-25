import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/utils/colors.dart';

class CommonFunctions {
  static blankSpace({
    required BuildContext context,
    required double reqHeight,
    required double reqWidth,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * reqHeight,
      width: width * reqWidth,
    );
  }

  static showToast({required BuildContext context, required String message}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: white,
        textColor: black,
        fontSize: 16.0);
  }
}
