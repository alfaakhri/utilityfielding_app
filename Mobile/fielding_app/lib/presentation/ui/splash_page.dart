import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset('assets/bg_splash.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
