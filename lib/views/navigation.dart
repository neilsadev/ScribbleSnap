import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scribblesnap/views/authscreen.dart';
import 'package:scribblesnap/views/homescreen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  navigateToScreen(BuildContext context) {
    try {
      print(auth.currentUser?.uid ?? "nada");
      if (auth.currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ),
            (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      navigateToScreen(context);
    });

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.asset(
            'assets/images/banner.png',
          ),
        ),
      ),
    );
  }
}
