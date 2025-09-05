import 'package:flutter/material.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();

    // Start text animation after logo starts
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Start fade animation
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();

    // Navigate to next screen after animations complete
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      // TODO: Navigate to onboarding or home screen
      print('Navigate to next screen');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF123459), // Custom blue background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _logoRotationAnimation.value * 0.1,
                      child: _buildLogo(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // App Name
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildAppName(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Description Text
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildDescription(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(painter: SkipLineLogoPainter()),
    );
  }

  Widget _buildAppName() {
    return const Text(
      'SkipLine',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Smart Self-Checkout App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Designed to speed up your\nservice at local stores',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Custom painter for the SK logo
class SkipLineLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final logoSize = size.width * 0.6;

    // Draw S
    final sPath = Path();
    sPath.moveTo(centerX - logoSize / 2, centerY - logoSize / 3);
    sPath.lineTo(centerX + logoSize / 2, centerY - logoSize / 3);
    sPath.moveTo(centerX - logoSize / 2, centerY);
    sPath.lineTo(centerX + logoSize / 2, centerY);
    sPath.moveTo(centerX - logoSize / 2, centerY + logoSize / 3);
    sPath.lineTo(centerX + logoSize / 2, centerY + logoSize / 3);

    // Vertical line for S
    sPath.moveTo(centerX - logoSize / 2, centerY - logoSize / 3);
    sPath.lineTo(centerX - logoSize / 2, centerY + logoSize / 3);

    // Draw K
    final kPath = Path();
    kPath.moveTo(centerX + logoSize / 4, centerY - logoSize / 3);
    kPath.lineTo(centerX + logoSize / 4, centerY + logoSize / 3);
    kPath.moveTo(centerX + logoSize / 4, centerY);
    kPath.lineTo(centerX + logoSize / 2, centerY - logoSize / 3);
    kPath.moveTo(centerX + logoSize / 4, centerY);
    kPath.lineTo(centerX + logoSize / 2, centerY + logoSize / 3);

    canvas.drawPath(sPath, paint);
    canvas.drawPath(kPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
