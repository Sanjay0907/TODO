import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/provider/auth_provider.dart';
import 'package:todo/controller/provider/todo_provider.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/view/auth_screen/sign_in_logic.dart';
import 'package:todo/view/todo_screen/new_todo.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Todo());
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<TODOProvider>(create: (_) => TODOProvider()),
      ],
      child: MaterialApp(
        home: const SignInLogic(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontFamily: 'Rampart One',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: white),
            displayMedium: TextStyle(
                fontFamily: 'Rampart One',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: white),
            displaySmall: TextStyle(
                // fontFamily: 'Rampart One',
                fontSize: 16,
                color: white),
            bodyMedium: TextStyle(
                // fontFamily: 'Rampart One',
                fontSize: 16,
                color: black),
            bodySmall: TextStyle(
                // fontFamily: 'Rampart One',
                fontSize: 14,
                color: black),
          ),
        ),
      ),
    );
  }
}
