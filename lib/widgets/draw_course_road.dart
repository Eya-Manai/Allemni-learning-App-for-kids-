import 'package:allemni/constants/colors.dart';
import 'package:flutter/widgets.dart';

class DrawCoursePath extends CustomPainter {
  final List<Offset> points;

  DrawCoursePath({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      throw Exception("No points provided for drawing path");
    }
    final paint = Paint()
      ..color = AppColors.lightYellow
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.quadraticBezierTo(
          points[i - 1].dx + points[i].dx / 2,
          points[i - 1].dy + points[i].dy / 2,
          points[i].dx,
          points[i].dy,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
