import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProposalPage extends StatefulWidget {
  const ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  String comment = "";
  String gifPath = "";
  bool userClickedNo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 60,
              children: [
                _gifSection(),
                _textSection(),
                _buttonSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gifSection() {
    return Column(
      spacing: 20,
      children: [
        if (gifPath.isNotEmpty) Image.asset(gifPath, height: 300, width: double.infinity, fit: BoxFit.fitHeight),
        Text(
          comment,
          style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily, fontSize: 12, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _textSection() {
    return Column(
      spacing: 8,
      children: [
        AnimatedTextKit(
          totalRepeatCount: 1,
          animatedTexts: [
            TypewriterAnimatedText(
              "Will you be my valentine?",
              textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
              speed: Duration(milliseconds: 70),
            ),
          ],
        ),
        AnimatedTextKit(
          totalRepeatCount: 1,
          animatedTexts: [
            FlickerAnimatedText(
              speed: Duration(seconds: 5),
              "(forever)",
              textStyle: TextStyle(fontFamily: GoogleFonts.lato().fontFamily, fontSize: 12, fontWeight: FontWeight.w300),
            )
          ],
        )
      ],
    );
  }

  Widget _buttonSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 40,
      children: [
        if (!userClickedNo)
          FilledButton(
            onPressed: () {
              gifPath = "assets/gifs/angry.gif";
              comment = "You have no choice";
              userClickedNo = true;
              setState(() {});
            },
            child: Text("no", style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily, fontSize: 12, fontWeight: FontWeight.w300)),
          ),
        FilledButton(
          onPressed: () {
            gifPath = "assets/gifs/happy.gif";
            comment = "我爱你\nWǒ ài nǐ";
            setState(() {});
          },
          child: Text(
            "YESSS",
            style: TextStyle(fontFamily: GoogleFonts.lato().fontFamily, fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
