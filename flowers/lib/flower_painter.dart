// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class FlowerPainter extends CustomPainter {
  BuildContext context;
  FlowerPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    //draw stem
    final stemPainter = Paint()
      ..color = Colors.black
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;
    Path stem = Path();

    double stemHeight = 320;
    double stemWidth = 16;

    double startStemX = (size.width / 2);
    double startStemY = size.height - 0; //48 is lower padding
    double endStemX = startStemX + stemWidth;
    double endStemY = startStemY - stemHeight;

    stem.moveTo(startStemX, startStemY);
    stem.quadraticBezierTo(endStemX + 32, endStemY + (stemHeight * 0.5), endStemX, endStemY);
    canvas.drawPath(stem, stemPainter);
    stemPainter.strokeWidth = 13;
    stemPainter.color = Colors.green;
    canvas.drawPath(stem, stemPainter);

    //draw pistil
    final pistilPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    const double pistilRadius = 25;
    const double innerPistilRadius = 15;

    canvas.drawCircle(Offset(endStemX, endStemY), pistilRadius, pistilPainter);
    pistilPainter.color = Colors.yellow;
    canvas.drawCircle(Offset(endStemX, endStemY), pistilRadius - 1, pistilPainter);
    pistilPainter.color = Colors.black;
    canvas.drawCircle(Offset(endStemX, endStemY), innerPistilRadius, pistilPainter);
    pistilPainter.color = Colors.orange[700]!;
    canvas.drawCircle(Offset(endStemX, endStemY), innerPistilRadius - 1, pistilPainter);

    //draw petals
    final petalPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    const int petalCount = 7;
    const double petalLength = 120;

    final blackPetals = Petal.getPetals(Offset(endStemX, endStemY), pistilRadius, petalCount, petalLength + 5);
    Petal.drawPetals(blackPetals, canvas, petalPainter);

    final petals = Petal.getPetals(Offset(endStemX, endStemY), pistilRadius, petalCount, petalLength);
    petalPainter.color = Colors.blue;
    Petal.drawPetals(petals, canvas, petalPainter);

    //draw leaves
    final leafPainter = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final stemMetrics = stem.computeMetrics().first;
    const leafLength = 110.0;

    final rLeafUp = Leafv3.getRightLeaf(stemMetrics, stemHeight, stemWidth, leafLength, up: true);
    Leafv3.drawLeaf(canvas, leafPainter, rLeafUp);
    final rLeafDown = Leafv3.getRightLeaf(stemMetrics, stemHeight, stemWidth, leafLength, down: true);
    Leafv3.drawLeaf(canvas, leafPainter, rLeafDown);
    leafPainter.color = Colors.green;
    final rLeaf = Leafv3.getRightLeaf(stemMetrics, stemHeight, stemWidth, leafLength);
    Leafv3.drawLeaf(canvas, leafPainter, rLeaf);

    leafPainter.color = Colors.black;
    final lLeafUp = Leafv3.geLeftLeaf(stemMetrics, stemHeight, stemWidth, leafLength, up: true);
    Leafv3.drawLeaf(canvas, leafPainter, lLeafUp);
    final lLeafDown = Leafv3.geLeftLeaf(stemMetrics, stemHeight, stemWidth, leafLength, down: true);
    Leafv3.drawLeaf(canvas, leafPainter, lLeafDown);
    leafPainter.color = Colors.green;
    final lLeaf = Leafv3.geLeftLeaf(stemMetrics, stemHeight, stemWidth, leafLength);
    Leafv3.drawLeaf(canvas, leafPainter, lLeaf);

    //total height is 320 + 25 + 120 + 5
    //but somehow 450 suffices
    //total width is 120*2 + 25*2
    //300 nice round figure
  }

  @override
  bool shouldRepaint(FlowerPainter oldDelegate) => true;
}

class Petal {
  double startX;
  double startY;
  double endX;
  double endY;
  double control1X;
  double control1Y;
  double control2X;
  double control2Y;
  Petal({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.control1X,
    required this.control1Y,
    required this.control2X,
    required this.control2Y,
  });

  static List<Petal> getPetals(Offset center, double radius, int petalCount, double petalLength) {
    List<Petal> petals = [];
    double angle = 0;
    double angleIncrement = (2 * 3.14) / petalCount;
    for (int i = 0; i < petalCount; i++) {
      double startX = center.dx + (radius * cos(angle));
      double startY = center.dy + (radius * sin(angle));
      double endX = center.dx + (radius * cos(angle + angleIncrement));
      double endY = center.dy + (radius * sin(angle + angleIncrement));

      double control1Angle = angle + (angleIncrement * 0.1);
      double control1X = center.dx + (petalLength * cos(control1Angle));
      double control1Y = center.dy + (petalLength * sin(control1Angle));

      double control2Angle = angle + (angleIncrement * 0.9);
      double control2X = center.dx + (petalLength * cos(control2Angle));
      double control2Y = center.dy + (petalLength * sin(control2Angle));
      petals.add(Petal(startX: startX, startY: startY, endX: endX, endY: endY, control1X: control1X, control1Y: control1Y, control2X: control2X, control2Y: control2Y));
      angle += angleIncrement;
    }
    return petals;
  }

  static drawPetals(List<Petal> petals, Canvas canvas, Paint petalPainter) {
    for (Petal p in petals) {
      final petalPath = Path();
      petalPath.moveTo(p.startX, p.startY);
      petalPath.cubicTo(p.control1X, p.control1Y, p.control2X, p.control2Y, p.endX, p.endY);
      canvas.drawPath(petalPath, petalPainter);
    }
  }
}

class Leafv3 {
  Offset base;
  Offset tip;
  Offset c1;
  Offset c2;
  Offset c3;
  Offset c4;

  Leafv3({required this.base, required this.tip, required this.c1, required this.c2, required this.c3, required this.c4});

  static Leafv3 getRightLeaf(PathMetric stemMetrics, double stemHeight, double stemWidth, double leafLength, {bool up = false, bool down = false}) {
    double u = up ? 0.005 : 0;
    double d = down ? -0.005 : 0;
    Tangent t1 = stemMetrics.getTangentForOffset(stemHeight * (0.45 + u + d))!;
    Tangent t2 = stemMetrics.getTangentForOffset(stemHeight * (0.25 + u + d))!;
    Tangent t3 = stemMetrics.getTangentForOffset(stemHeight * (0.55 + u + d))!;

    final p1 = Offset(
      t1.position.dx + stemWidth * 0.6,
      t1.position.dy,
    );

    double angle = t1.angle * (180 / pi);
    angle = angle - 45;
    angle = angle * (pi / 180);

    final p2 = Offset(
      p1.dx + (leafLength * cos(angle)),
      p1.dy - (leafLength * sin(angle)),
    );

    final c1 = Offset(
      p1.dx + (leafLength * 0.25 * cos(angle)),
      p1.dy - (leafLength * 0.25 * sin(angle)),
    );

    final tx1 = (t2.position.dx + stemWidth * 0.6);
    final ty1 = t2.position.dy;
    double a2 = t1.angle * (180 / pi);
    a2 = a2 - 45;
    a2 = a2 * (pi / 180);

    final c2 = Offset(
      tx1 + (leafLength * cos(a2)),
      ty1 - (leafLength * sin(a2)),
    );

    final c3 = Offset(
      p1.dx + (leafLength * 0.75 * cos(angle)),
      p1.dy - (leafLength * 0.75 * sin(angle)),
    );

    final c4 = Offset(
      t3.position.dx + stemWidth * 0.6,
      t3.position.dy,
    );

    final leaf = Leafv3(base: p1, tip: p2, c1: c1, c2: c2, c3: c3, c4: c4);
    return leaf;
  }

  static Leafv3 geLeftLeaf(PathMetric stemMetrics, double stemHeight, double stemWidth, double leafLength, {bool up = false, bool down = false}) {
    double u = up ? 0.005 : 0;
    double d = down ? -0.005 : 0;

    Tangent t1 = stemMetrics.getTangentForOffset(stemHeight * (0.25 + u + d))!;
    Tangent t2 = stemMetrics.getTangentForOffset(stemHeight * (0.05 + u + d))!;
    Tangent t3 = stemMetrics.getTangentForOffset(stemHeight * (0.35 + u + d))!;

    final p1 = Offset(
      t1.position.dx - stemWidth * 0.6,
      t1.position.dy,
    );

    double angle = t1.angle * (180 / pi);
    angle = 180 - (angle + 45);
    angle = angle * (pi / 180);

    final p2 = Offset(
      p1.dx - (leafLength * cos(angle)),
      p1.dy - (leafLength * sin(angle)),
    );

    final c1 = Offset(
      p1.dx - (leafLength * 0.25 * cos(angle)),
      p1.dy - (leafLength * 0.25 * sin(angle)),
    );

    final tx1 = (t2.position.dx - stemWidth * 0.6);
    final ty1 = t2.position.dy;
    double a2 = t1.angle * (180 / pi);
    a2 = 180 - (a2 + 45);
    a2 = a2 * (pi / 180);

    final c2 = Offset(
      tx1 - (leafLength * cos(a2)),
      ty1 - (leafLength * sin(a2)),
    );

    final c3 = Offset(
      p1.dx - (leafLength * 0.75 * cos(angle)),
      p1.dy - (leafLength * 0.75 * sin(angle)),
    );

    final c4 = Offset(
      t3.position.dx - stemWidth * 0.6,
      t3.position.dy,
    );

    final leaf = Leafv3(base: p1, tip: p2, c1: c1, c2: c2, c3: c3, c4: c4);
    return leaf;
  }

  static drawLeaf(Canvas canvas, Paint leafPainter, Leafv3 l) {
    Path leafPath = Path();

    leafPath.moveTo(l.base.dx, l.base.dy);
    leafPath.cubicTo(l.c1.dx, l.c1.dy, l.c2.dx, l.c2.dy, l.tip.dx, l.tip.dy);
    leafPath.cubicTo(l.c3.dx, l.c3.dy, l.c4.dx, l.c4.dy, l.base.dx, l.base.dy);

    canvas.drawPath(leafPath, leafPainter);
  }
}

// class Leafv2 {
//   Offset p1;
//   Offset p2;
//   Offset p3;
//   Offset p4;
//   Offset p5;
//   Offset cp1;
//   Offset cp2;
//   Offset cp3;
//   Offset cp4;
//   Offset cp5;
//   Offset cp6;

//   Leafv2({
//     required this.p1,
//     required this.p2,
//     required this.p3,
//     required this.p4,
//     required this.p5,
//     required this.cp1,
//     required this.cp2,
//     required this.cp3,
//     required this.cp4,
//     required this.cp5,
//     required this.cp6,
//   });

//   static getLeaves(double stemHeight, double stemWidth, PathMetric stemMetrics, int leafCount, double leafLength, double leafWidth) {
//     List<Leafv2> leaves = [];
//     for (int i = 1; i <= leafCount; i++) {
//       Tangent t1 = stemMetrics.getTangentForOffset(stemHeight * 0.2 * i)!;
//       Tangent t2 = stemMetrics.getTangentForOffset(stemHeight * 0.24 * i)!;
//       Tangent t3 = stemMetrics.getTangentForOffset(stemHeight * 0.22 * i)!;

//       final n = 1 * pow(-1, i); //n is negator

//       double x1 = t1.position.dx + stemWidth * 0.6 * n;
//       double y1 = t1.position.dy;
//       double angle = t1.angle * (180 / pi);
//       angle = i.isOdd ? 180 - (angle + 45) : angle - 45; //180 - (angle + 45) for left side leaves
//       angle = angle * (pi / 180);

//       double x2 = x1 + (leafLength * cos(angle) * n);
//       double y2 = y1 - (leafLength * sin(angle));

//       double x3 = t2.position.dx + stemWidth * 0.6 * n;
//       double y3 = t2.position.dy;

//       double x4 = t3.position.dx + stemWidth * 0.6 * n;
//       double y4 = t3.position.dy;

//       double x5 = x4 + ((leafLength * 0.8) * cos(angle) * n);
//       double y5 = y4 - ((leafLength * 0.8) * sin(angle));

//       // double cx1 = x1 + (x1 - x2) * 0.7 * n;
//       // double cy1 = y1 - (y1 - y2) * 0.7 * n;

//       // double cx2 = x1 + (x1 - x2) * 0.5 + leafWidth * 0.5 * n;
//       // double cy2 = y1 + (y1 - y2) * 0.5;

//       // double cx3 = x3 + (x3 + x2) * 0.3;
//       // double cy3 = y1 + (y3 + y2) * 0.3;

//       // double cx4 = x3 + (x3 + x2) * 0.5 + leafWidth * 0.5;
//       // double cy4 = y1 + (y3 + y2) * 0.5;

//       // double cx5 = x4 + (x4 + x5) * 0.7;
//       // double cy5 = y4 + (y4 + y5) * 0.7;

//       // double cx6 = x4 + (x4 + x5) * 0.5 + leafWidth * 0.5;
//       // double cy6 = y4 + (y4 + y5) * 0.5;

//       final cp1 = Offset(
//         x1 + (x2 - x1) * 0.7 * n - leafWidth * 0.5 * n,
//         y1 + (y2 - y1) * 0.7,
//       );

//       final cp2 = Offset(
//         x1 - (x2 - x1) * 0.5 * n - leafWidth * 0.5 * n,
//         y1 + (y2 - y1) * 0.5,
//       );

//       final cp3 = Offset(
//         x3 + (x2 - x3) * 0.3,
//         y3 + (y2 - y3) * 0.3,
//       );

//       final cp4 = Offset(
//         x3 + (x2 - x3) * 0.5 + leafWidth * 0.5 * n,
//         y3 + (y2 - y3) * 0.5,
//       );

//       final cp5 = Offset(
//         x4 + (x5 - x4) * 0.3,
//         y4 + (y5 - y4) * 0.3,
//       );

//       final cp6 = Offset(
//         x4 + (x5 - x4) * 0.5 + leafWidth * 0.5 * n,
//         y4 + (y5 - y4) * 0.5,
//       );

//       final leaf = Leafv2(
//         p1: Offset(x1, y1),
//         p2: Offset(x2, y2),
//         p3: Offset(x3, y3),
//         p4: Offset(x4, y4),
//         p5: Offset(x5, y5),
//         cp1: cp1,
//         cp2: cp2,
//         cp3: cp3,
//         cp4: cp4,
//         cp5: cp5,
//         cp6: cp6,
//       );
//       leaves.add(leaf);
//     }
//     return leaves;
//   }

//   static drawLeaves(List<Leafv2> leaves, Canvas canvas, Paint leafPainter) {
//     for (Leafv2 l in leaves) {
//       // final l = leaves[0];
//       final leaf = Path();
//       leaf.moveTo(l.p1.dx, l.p1.dy);
//       leaf.cubicTo(l.cp1.dx, l.cp1.dy, l.cp2.dx, l.cp2.dy, l.p2.dx, l.p2.dy);
//       // leaf.cubicTo(l.cp3.dx, l.cp3.dy, l.cp4.dx, l.cp4.dy, l.p3.dx, l.p3.dy);
//       canvas.drawPath(leaf, leafPainter);
//     }
//   }

  // static void drawLeaves(List<Leafv2> leaves, Canvas canvas, Paint leafPaint) {
  //   for (var leaf in leaves) {
  //     final path = Path();

  //     // Start at the base of the leaf
  //     path.moveTo(leaf.p1.dx, leaf.p1.dy);

  //     // Draw top curve of leaf
  //     path.cubicTo(leaf.cp1.dx, leaf.cp1.dy, leaf.cp2.dx, leaf.cp2.dy, leaf.p2.dx, leaf.p2.dy);

  //     // Draw bottom curve back to base
  //     path.cubicTo(leaf.cp4.dx, leaf.cp4.dy, leaf.cp3.dx, leaf.cp3.dy, leaf.p1.dx, leaf.p1.dy);

  //     path.close();
  //     canvas.drawPath(path, leafPaint);
  //   }
  // }
// }

// class Leaf {
//   double startX;
//   double startY;
//   double endX;
//   double endY;
//   double control1X;
//   double control1Y;
//   double control2X;
//   double control2Y;

//   Leaf({
//     required this.startX,
//     required this.startY,
//     required this.endX,
//     required this.endY,
//     required this.control1X,
//     required this.control1Y,
//     required this.control2X,
//     required this.control2Y,
//   });

//   static List<Leaf> getLeaves(double stemHeight, double stemWidth, PathMetric stemMetrics, int leafCount, double leafLength) {
//     List<Leaf> leaves = [];

//     for (int i = 1; i <= leafCount; i++) {
//       Tangent tangent = stemMetrics.getTangentForOffset(stemHeight * 0.2 * i)!;
//       double startX = tangent.position.dx + stemWidth * 0.6 * pow(-1, i);
//       double startY = tangent.position.dy;
//       double angle = tangent.angle * (180 / pi);
//       angle = i.isOdd ? 180 - (angle + 45) : angle - 45; //180 - (angle + 45) for left side leaves
//       angle = angle * (pi / 180);
//       Logger().f('angle: ${angle * 180 / pi}');

//       double endX = startX + (leafLength * cos(angle) * pow(-1, i));
//       double endY = startY - (leafLength * sin(angle));

//       double control1X = ((startX + endX) * 0.5) + (50 * pow(-1, i));
//       double control1Y = (startY + endY) * 0.5;
//       double control2X = ((startX + endX) * 0.5) - (50 * pow(-1, i));
//       double control2Y = (startY + endY) * 0.5;

//       leaves.add(Leaf(startX: startX, startY: startY, endX: endX, endY: endY, control1X: control1X, control1Y: control1Y, control2X: control2X, control2Y: control2Y));
//     }
//     return leaves;
//   }

//   static drawLeaves(List<Leaf> leaves, Canvas canvas, Paint leafPainter) {
//     for (Leaf l in leaves) {
//       final leaf = Path();
//       leaf.moveTo(l.startX, l.startY);
//       leaf.quadraticBezierTo(l.control1X, l.control1Y, l.endX, l.endY);
//       leaf.quadraticBezierTo(l.control2X, l.control2Y, l.startX, l.startY);
//       leaf.close();
//       canvas.drawPath(leaf, leafPainter);
//     }
//   }
// }

