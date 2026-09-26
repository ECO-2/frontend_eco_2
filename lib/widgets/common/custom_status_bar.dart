import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class CustomStatusBar extends StatelessWidget {
  final Color backgroundColor;

  const CustomStatusBar({
    super.key,
    this.backgroundColor = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkBackground = ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark;

    // Enforce transparent OS status bar so our custom widget shines through
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkBackground ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkBackground ? Brightness.dark : Brightness.light,
      ),
    );

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: backgroundColor,
      height: statusBarHeight > 0 ? statusBarHeight : 20.0,
    );
  }
}
