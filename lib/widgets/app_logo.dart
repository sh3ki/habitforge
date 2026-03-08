import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool darkBackground;

  const AppLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.darkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF9800)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.bolt_rounded,
                    color: Colors.white, size: size * 0.6),
                Positioned(
                  bottom: size * 0.06,
                  right: size * 0.06,
                  child: Container(
                    width: size * 0.3,
                    height: size * 0.3,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Icon(Icons.local_fire_department_rounded,
                          color: Colors.white, size: size * 0.18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Habit',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.w800,
                    color: darkBackground
                        ? Colors.white
                        : AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                TextSpan(
                  text: 'Forge',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
