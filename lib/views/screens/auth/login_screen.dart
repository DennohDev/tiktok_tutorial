import 'package:flutter/material.dart';
import 'package:tiktok_tutorial/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              'TikTok Clone',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: buttonColor,
                fontSize: 35,
              ),
            ),
            Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
            ),
            const SizedBox(
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}
