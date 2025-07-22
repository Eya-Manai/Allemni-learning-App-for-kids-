import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:allemni/constants/colors.dart';
import 'package:path_drawing/path_drawing.dart';

class DrawCoursePath extends CustomPainter {
  final List<Offset> points;
  final double nodeRadius;
  final List<ui.Image>? icons;

  DrawCoursePath({required this.points, this.nodeRadius = 30, this.icons});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final borderPaint = Paint()
      ..color = AppColors.lightYellow
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final roadPaint = Paint()
      ..color = AppColors.roadgray
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i], p2 = points[i + 1];
      final cp1 = Offset((p1.dx + p2.dx) / 2, p1.dy);
      final cp2 = Offset((p1.dx + p2.dx) / 2, p2.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    final dashPattern = CircularIntervalList<double>([
      10,
      10,
    ]); // 10px dash, 10px gap
    final dashedPath = dashPath(path, dashArray: dashPattern);
    canvas.drawPath(dashedPath, borderPaint);
    canvas.drawPath(dashedPath, roadPaint);

    final fillNode = Paint()..color = AppColors.primaryYellow;

    for (int i = 0; i < points.length; i++) {
      final c = points[i];
      final shadowPaint = Paint()
        ..color = AppColors.black
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(c.translate(0, 3), nodeRadius, shadowPaint);

      canvas.drawCircle(c, nodeRadius, fillNode);

      // 3) draw icon if loaded
      if (icons != null && i < icons!.length) {
        final img = icons![i];
        final src = Rect.fromLTWH(
          0,
          0,
          img.width.toDouble(),
          img.height.toDouble(),
        );
        final dst = Rect.fromCircle(center: c, radius: nodeRadius * 0.7);
        canvas.drawImageRect(img, src, dst, Paint());
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawCoursePath old) =>
      old.points != points || old.icons != icons;
}
