import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({super.key, this.size = 48, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Center(
            child: Text(
              'H',
              style: TextStyle(
                fontSize: size * 0.52,
                fontWeight: FontWeight.w900,
                color: AppTheme.secondary,
              ),
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
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                TextSpan(
                  text: 'Forge',
                  style: TextStyle(
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.secondary,
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
