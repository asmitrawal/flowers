import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatingText extends StatelessWidget {
  const AnimatingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text("Hi", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400)),
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                "Sagarika",
                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                speed: Duration(milliseconds: 70),
              ),
              TyperAnimatedText(
                "Beautiful",
                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                speed: Duration(milliseconds: 70),
              ),
              TyperAnimatedText(
                "Fuchhhyyyyyy",
                textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                speed: Duration(milliseconds: 70),
              ),
          
            ],
            totalRepeatCount: 1,
          ),
        ],
      ),
    );
  }
}
