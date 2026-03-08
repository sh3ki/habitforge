import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
    _slide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve:
                    const Interval(0.3, 0.8, curve: Curves.easeOut)));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainNavigation(),
            transitionsBuilder: (_, a, __, child) =>
                FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF9800), Color(0xFFFFC107)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, child) => FadeTransition(
                      opacity: _fade,
                      child: Transform.scale(
                        scale: _scale.value,
                        child: child,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 2),
                          ),
                          child: const Center(
                            child: AppLogo(size: 64, showText: false),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SlideTransition(
                          position: _slide,
                          child: Column(
                            children: [
                              const Text(
                                'HabitForge',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Build habits. Build yourself.',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (i) => Container(
                            width: i == 1 ? 24 : 8,
                            height: 8,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(i == 1 ? 1.0 : 0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your streak starts today 🔥',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
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
