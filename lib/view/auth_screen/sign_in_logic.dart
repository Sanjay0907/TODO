import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo/controller/services/auth.dart';
import 'package:todo/view/auth_screen/sign_in_screen.dart';
import 'package:todo/view/todo_screen/todo_screen.dart';

class SignInLogic extends StatefulWidget {
  const SignInLogic({super.key});

  @override
  State<SignInLogic> createState() => _SignInLogicState();
}

class _SignInLogicState extends State<SignInLogic> {
  checkAuthentication() {
    bool userAlreadyAuthenticated = Auth.checkAuthentication();
    userAlreadyAuthenticated
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TodoScreen()),
            (route) => false)
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){

  checkAuthentication();

});

  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Text(
        'TODO',
        style: textTheme.displayLarge,
      ),
    );
  }
}
