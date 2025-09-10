import 'package:flutter/material.dart';
import 'dart:math' as math;

class ScanOverlay extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final Animation<double> scanLineAnimation;

  const ScanOverlay({
    super.key,
    required this.pulseAnimation,
    required this.scanLineAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pulseAnimation, scanLineAnimation]),
      builder: (context, child) {
        return Stack(
          children: [
            // طبقة التعتيم
            _buildDimmingLayer(),

            // منطقة المسح
            _buildScanArea(),

            // خط المسح المتحرك
            _buildScanLine(),

            // الزوايا المتحركة
            _buildAnimatedCorners(),

            // النقاط المتحركة
            _buildAnimatedDots(),
          ],
        );
      },
    );
  }

  Widget _buildDimmingLayer() {
    return Container(color: Colors.black.withOpacity(0.6));
  }

  Widget _buildScanArea() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanLine() {
    return Center(
      child: Container(
        width: 250,
        height: 2,
        child: CustomPaint(
          painter: ScanLinePainter(animation: scanLineAnimation),
        ),
      ),
    );
  }

  Widget _buildAnimatedCorners() {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            // الزاوية العلوية اليسرى
            Positioned(
              top: 0,
              left: 0,
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: pulseAnimation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                          left: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // الزاوية العلوية اليمنى
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: pulseAnimation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                          right: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // الزاوية السفلية اليسرى
            Positioned(
              bottom: 0,
              left: 0,
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: pulseAnimation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                          left: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // الزاوية السفلية اليمنى
            Positioned(
              bottom: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: pulseAnimation.value,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                          right: BorderSide(
                            color: const Color(0xFF00E676),
                            width: 4,
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            // النقاط المتحركة حول المحيط
            ...List.generate(8, (index) {
              final angle = (index * 45) * (3.14159 / 180);
              final radius = 125.0;
              final x = radius + (radius - 20) * cos(angle);
              final y = radius + (radius - 20) * sin(angle);

              return Positioned(
                left: x - 4,
                top: y - 4,
                child: AnimatedBuilder(
                  animation: pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: pulseAnimation.value,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E676).withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ScanLinePainter extends CustomPainter {
  final Animation<double> animation;

  ScanLinePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFF00E676),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final y = animation.value * size.height;

    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

double cos(double angle) {
  return math.cos(angle);
}

double sin(double angle) {
  return math.sin(angle);
}
