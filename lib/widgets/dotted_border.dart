import 'package:flutter/material.dart';

class DottedBorder extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Color color;
  final double gap;
  final double dash;

  const DottedBorder({
    super.key,
    required this.child,
    this.strokeWidth = 1,
    this.color = Colors.black,
    this.gap = 4,
    this.dash = 6,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        strokeWidth: strokeWidth,
        color: color,
        gap: gap,
        dash: dash,
      ),
      child: child,
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gap;
  final double dash;

  _DottedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.gap,
    required this.dash,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Offset.zero & size,
            const Radius.circular(8), // rounded corners
          ),
        );

    // Draw the path with dash effect
    double distance = 0.0;
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dash);
        canvas.drawPath(segment, paint);
        distance += dash + gap;
      }
      distance = 0.0; // reset for next side
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
