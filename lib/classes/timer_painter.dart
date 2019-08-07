import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimerPaiter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;
  final double circleSize;
  TimerPaiter(
      this.animation, this.backgroundColor, this.color, this.circleSize);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(size.center(Offset.zero), circleSize, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPaiter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
