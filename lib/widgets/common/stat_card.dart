import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? valueColor;
  final bool isDark;
  final bool showBorder;
  final double? valueFontSize;
  final double? labelFontSize;
  final String? fontFamily;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.valueColor,
    this.isDark = false,
    this.showBorder = false,
    this.valueFontSize,
    this.labelFontSize,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: isDark ? AppColors.accent : (valueColor ?? AppColors.primary),
            size: 28,
          ),
          const SizedBox(height: 4),
        ],
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize ?? (icon != null ? 18 : 24),
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : (valueColor ?? AppColors.textPrimary),
              fontFamily: fontFamily ?? 'Inter',
            ),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize ?? 11,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );

    if (showBorder) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E7E4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: content,
      );
    }

    return content;
  }
}
