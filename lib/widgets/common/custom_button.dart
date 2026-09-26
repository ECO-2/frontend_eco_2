import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final BorderSide? side;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width = double.infinity,
    this.side,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalBorderRadius = borderRadius ?? BorderRadius.circular(20); // Figma standard border radius
    final bool isEnabled = onPressed != null && !isLoading;

    Widget button;

    if (isOutlined) {
      button = OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? theme.colorScheme.primary,
          side: side ?? BorderSide(color: backgroundColor ?? theme.colorScheme.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: finalBorderRadius),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: _buildChild(theme),
      );
    } else {
      button = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
          disabledBackgroundColor: (backgroundColor ?? theme.colorScheme.primary).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: finalBorderRadius),
          side: side,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: _buildChild(theme),
      );
    }

    Widget result = button;
    if (width != null || height != null) {
      result = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return Bounceable(
      onTap: isEnabled ? () {} : null,
      child: result,
    );
  }

  Widget _buildChild(ThemeData theme) {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
