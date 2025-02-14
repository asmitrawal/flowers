import 'dart:math';

import 'package:flowers/flower_painter.dart';
import 'package:flowers/proposal_page.dart';
import 'package:flutter/material.dart';

class FlowerPage extends StatefulWidget {
  const FlowerPage({super.key});

  @override
  State<FlowerPage> createState() => FlowerPageState();
}

class FlowerPageState extends State<FlowerPage> with TickerProviderStateMixin {
  List<Widget> hearts = [];
  double textOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  GestureDetector(
                    onTap: () => _startHeartsAnimation(),
                    child: CustomPaint(
                      painter: FlowerPainter(context),
                      size: Size(300, 450),
                    ),
                    onLongPress: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProposalPage(),
                        )),
                  ),
                  Text(
                    "Tap on the flower for a surprise...",
                    style: TextStyle(fontFamily: "Lato", fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1000),
                    opacity: textOpacity,
                    child: Text("Long press to continue...", style: TextStyle(fontFamily: "Lato", fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            ...hearts,
          ],
        ),
      ),
    );
  }

  _startHeartsAnimation() {
    hearts = List.generate(
      15,
      (index) {
        double leftStart = Random().nextDouble() * MediaQuery.of(context).size.width;
        final color = Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 0.8);
        double startHeight = Random().nextDouble() * MediaQuery.of(context).size.height * 0.2;
        int duration = Random().nextInt(3000) + 2000;
        double rotation = (Random().nextDouble() - 0.5) * 2;
        int delay = Random().nextInt(50); // Random delay between 0ms and 1000ms
        double drift = (Random().nextDouble() - 0.5) * 200; // Slight horizontal drift (-100 to 100)

        final AnimationController animationController = AnimationController(vsync: this, duration: Duration(milliseconds: duration));
        final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: animationController, curve: Curves.bounceOut));

        // animationController.forward();
        Future.delayed(Duration(milliseconds: delay), () {
          animationController.forward();
        });

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: leftStart + animation.value * drift,
              // top: animation.value * MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - 30,
              top: startHeight + (animation.value * (MediaQuery.of(context).size.height - startHeight)) - 60,
              child: Transform.rotate(
                angle: animation.value * rotation,
                child: Icon(Icons.favorite, color: color, size: 60),
              ),
            );
          },
        );
      },
    );
    textOpacity = 1.0;
    setState(() {});
  }
}
