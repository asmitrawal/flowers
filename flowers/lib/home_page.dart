import 'dart:math';

import 'package:flowers/flower_painter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<Widget> confetti = [const SizedBox.shrink()];
  List<Color> colors = [Colors.red, Colors.pink, Colors.yellow, Colors.orange[400]!, Colors.lightBlue, Colors.purple[300]!];

  final rand = Random();
  int scrH = 0;
  int scrW = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        scrH = MediaQuery.of(context).size.height.toInt();
        scrW = MediaQuery.of(context).size.width.toInt();
      },
    );
    super.initState();
  }

  showConfetti() {
    confetti = List.generate(
      18,
      (index) {
        return AnimatedPositioned(
          duration: const Duration(seconds: 7),
          left: rand.nextInt(scrW).toDouble(),
          top: rand.nextInt(scrH).toDouble(),
          child: Icon(
            Icons.favorite,
            color: colors[Random().nextInt(6)],
            size: 32,
          ),
        );
      },
    );
    setState(() {});
    Future.delayed(const Duration(seconds: 7), () => showConfetti());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => showConfetti(),
                    child: CustomPaint(painter: FlowerPainter(context), size: const Size(300, 450)),
                  )
                ],
              ),
            ),
            ...confetti,
          ],
        ),
      ),
    );
  }
}
