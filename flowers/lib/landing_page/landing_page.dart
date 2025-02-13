import 'package:flowers/flower_page.dart';
import 'package:flowers/landing_page/animating_text.dart';
import 'package:flowers/landing_page/pulsating_heart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 40,
            children: [
              AnimatingText(),
              GestureDetector(
                onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => FlowerPage()), (route) => true),
                child: PulsatingHeart(),
              ),
              Text(
                "Tap the heart to begin...",
                style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily, fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
