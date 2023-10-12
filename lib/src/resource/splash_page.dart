import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          text: TextSpan(
              text: "Design by Hieupro9x",
              style: TextStyle(color: Colors.green, fontSize: 22),
            ),
        ),

      ),
    );
  }
}
