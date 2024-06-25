import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen>
    with SingleTickerProviderStateMixin {
  DateTime _now = DateTime.now();
  late Timer _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double secondAngle = _now.second * 2 * pi / 60;
    double minutAngle = (_now.minute + _now.second / 60) * 2 * pi / 60;
    double hourAngle = (_now.hour % 12 + _now.minute / 60) * 2 * pi / 12;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.withOpacity(_controller.value),
                  Colors.blue.withOpacity(_controller.value),
                  Colors.indigo.withOpacity(_controller.value),
                  Colors.purple.withOpacity(_controller.value),
                ],
                stops: [
                  _controller.value,
                  (_controller.value + 0.4) % 1,
                  (_controller.value + 0.5) % 1,
                  (_controller.value + 0.6) % 1,
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(300, 300),
                    painter: TimePainter(),
                  ),
                  AnimatedRotation(
                    turns: secondAngle / (2 * pi),
                    duration: const Duration(seconds: 1),
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: SecondHandPainter(),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(seconds: 1),
                    turns: minutAngle / (2 * pi),
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: MinuteHandPainter(),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(seconds: 1),
                    turns: hourAngle / (2 * pi),
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter: HourHandPainter(),
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(_controller.value),
                          Colors.blue.withOpacity(_controller.value),
                          Colors.indigo.withOpacity(_controller.value),
                          Colors.purple.withOpacity(_controller.value),
                        ],
                        stops: [
                          _controller.value,
                          (_controller.value + 0.4) % 1,
                          (_controller.value + 0.5) % 1,
                          (_controller.value + 0.6) % 1,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: child,
                  );
                },
                child: Text(
                  '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}:${_now.second.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      110,
      paint,
    );

    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    const radius = 110.0;
    const tickLength = 10.0;

    for (int i = 0; i < 12; i++) {
      double angle = (i * 30) * pi / 180;
      Offset start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      Offset end = Offset(
        center.dx + (radius - tickLength) * cos(angle),
        center.dy + (radius - tickLength) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SecondHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width / 2, size.height / 2 - 10)
      ..lineTo(size.width / 2, size.height / 2 - 100);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MinuteHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width / 2, size.height / 2 - 10)
      ..lineTo(size.width / 2, size.height / 2 - 80);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class HourHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width / 2, size.height / 2 - 10)
      ..lineTo(size.width / 2, size.height / 2 - 70);

    canvas.drawPath(path, linePaint);

    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
