import 'package:flutter/material.dart';
import 'dart:math';

class RadialBackgroundPainter extends CustomPainter {
  final Color color;

  RadialBackgroundPainter({this.color = const Color(0xFFFFFFFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.85;

    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0; 

    // Total dashes
    const int dashCount = 60;
    const double angleStep = (2 * pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      // Determine color opacity/gradient simulation
      // Make bottom-left and bottom-right slightly more orange/active if desired, 
      // or just fade them out at the top.
      // For now, let's keep it uniform or slightly faded at the top.
      
      final double angle = i * angleStep;
      
      // Calculate start and end points for each dash
      final double startDist = radius;
      final double endDist = radius + 15; // Length of dash

      final p1 = Offset(
        center.dx + startDist * cos(angle),
        center.dy + startDist * sin(angle),
      );
      final p2 = Offset(
        center.dx + endDist * cos(angle),
        center.dy + endDist * sin(angle),
      );

      // Color logic: Highlight the bottom section (like the image example might suggest)
      // or just use the passed color with varying opacity.
      // Let's use a subtle gradient effect based on angle.
      double opacity = 0.3;
      
      // Highlight bottom semi-circle
      if (sin(angle) > 0) { 
        opacity = 0.6; 
      }
      
      paint.color = color.withOpacity(opacity);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
