library draw_lines;

import 'package:flutter/material.dart';

class Draw extends StatelessWidget {
  final Size size;
  final Color color;
  final double strokeWidth;
  Draw(
      {super.key,
      required this.size,
      this.color = Colors.red,
      this.strokeWidth = 2});

  final ValueNotifier<List<Point>> pointsToDraw =
      ValueNotifier<List<Point>>([]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: (details) {
          if (details.localPosition.dx > 0 && details.localPosition.dy > 0) {
            pointsToDraw.value = [
              ...pointsToDraw.value,
              Point(points: [details.localPosition])
            ];
          }
        },
        onPanUpdate: (details) => addPolygon(details.localPosition),
        onPanEnd: (details) => addPolygon(details.localPosition),
        child: ValueListenableBuilder(
          valueListenable: pointsToDraw,
          builder: (context, value, child) => CustomPaint(
            size: size,
            painter:
                _Polygon(points: value, color: color, strokeWidth: strokeWidth),
          ),
        ));
  }

  addPolygon(Offset localPosition) {
    if (localPosition.dx > 0 &&
        localPosition.dy > 0 &&
        localPosition.dy < size.height) {
      pointsToDraw.value.last.points.add(localPosition);
      pointsToDraw.value = [
        ...pointsToDraw.value,
      ];
    }
  }
}

class _Polygon extends CustomPainter {
  List<Point> points;
  Color color;
  double strokeWidth;
  _Polygon(
      {required this.points, required this.color, required this.strokeWidth});
  @override
  void paint(Canvas canvas, Size size) {
    for (var e in points) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      final path = Path();
      path.addPolygon(e.points, false);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Point {
  final List<Offset> points;
  Point({required this.points});
}
