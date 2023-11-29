import 'package:fastfoodweb/Screens/auth/admin_login.dart';
import 'package:fastfoodweb/Screens/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the user is already authenticated
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If user is authenticated, navigate to the menu screen
      return MenuScreen();
    } else {
      // If user is not authesnticated, navigate to the login screen

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminLoginPage()),
        );
      });

      return Scaffold(
        body: Stack(
          children: [
            // Background animation
            // const FlareActor(
            //   "assets/your_animation.flr",
            //   alignment: Alignment.center,
            //   fit: BoxFit.cover,
            //   animation:
            //       "idle",
            // ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/logo.png"),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
