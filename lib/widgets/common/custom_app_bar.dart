import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? statusBarColor;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = Colors.white,
    this.statusBarColor,
    this.bottom,
    this.toolbarHeight = 72.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading;
    if (leadingWidget == null && automaticallyImplyLeading) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      if (canPop) {
        leadingWidget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              customBorder: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: foregroundColor == Colors.white
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.1),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: foregroundColor,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      }
    }

    List<Widget>? appBarActions = actions;
    if (appBarActions == null && title != null) {
      final notificationsProvider = Provider.of<NotificationsProvider>(context);
      final unreadCount = notificationsProvider.unreadCount;

      appBarActions = [
        SizedBox(
          width: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: foregroundColor,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.notifications);
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error, // Red dot
                    ),
                  ),
                ),
            ],
          ),
        ),
      ];
    }

    final actualStatusBarColor =
        statusBarColor ??
        (backgroundColor == AppColors.primary
            ? AppColors.primaryDark
            : backgroundColor);

    final bool isDarkBackground =
        ThemeData.estimateBrightnessForColor(actualStatusBarColor) ==
        Brightness.dark;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AppBar(
      primary: true,
      toolbarHeight: toolbarHeight,
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Inter',
                  ),
                )
              : null),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leadingWidget,
      iconTheme: IconThemeData(color: foregroundColor),
      actions: appBarActions,
      bottom: bottom,
      flexibleSpace: Column(
        children: [
          Container(height: statusBarHeight, color: actualStatusBarColor),
          Expanded(child: Container(color: backgroundColor)),
        ],
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkBackground
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDarkBackground
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
