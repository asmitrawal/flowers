import 'package:flutter/material.dart';

class PulsatingHeart extends StatefulWidget {
  const PulsatingHeart({super.key});

  @override
  State<PulsatingHeart> createState() => _PulsatingHeartState();
}

class _PulsatingHeartState extends State<PulsatingHeart> with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    _scaleAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000))..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(_scaleAnimationController);
    super.initState();
  }

@override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            Positioned.fill(
              child: Icon(
                Icons.favorite,
                color: Colors.pink[100],
                size: 100,
              ),
            ),
            Positioned.fill(
              child: Icon(
                Icons.favorite,
                color: Colors.pink[200],
                size: 90,
              ),
            ),
            Positioned.fill(
              child: Icon(
                Icons.favorite,
                color: Colors.pink[300],
                size: 80,
              ),
            ),
            Positioned.fill(
              child: Icon(
                Icons.favorite,
                color: Colors.pink[400],
                size: 70,
              ),
            ),
            Positioned.fill(
              child: Icon(
                Icons.favorite,
                color: Colors.pink[500],
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
