import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool useIconContainer;
  final bool showArrow;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? titleColor;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.useIconContainer = false,
    this.showArrow = true,
    this.iconColor,
    this.iconBgColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;
    final primaryColor = iconColor ?? AppColors.primary;
    final bgColor = iconBgColor ?? const Color(0xFFF1F4F3);

    if (useIconContainer) {
      leadingWidget = Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      );
    } else {
      leadingWidget = Icon(icon, color: primaryColor, size: 24);
    }

    Widget? trailingWidget = trailing;
    if (trailingWidget == null && showArrow) {
      trailingWidget = const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
        size: 24,
      );
    }

    return ListTile(
      contentPadding: useIconContainer
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
          : const EdgeInsets.symmetric(vertical: 4),
      leading: leadingWidget,
      title: Text(
        title,
        // Sin esto, un subtitulo largo en el trailing dejaba al titulo sin
        // ancho y lo partia a la mitad. Ahora el titulo se recorta antes de
        // deformar la fila.
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: useIconContainer ? 15 : 16,
          color: titleColor ?? (useIconContainer ? AppColors.textPrimary : AppColors.primary),
          fontFamily: 'Inter',
        ),
      ),
      subtitle: (useIconContainer && subtitle != null)
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
              ),
            )
          : null,
      trailing: !useIconContainer && subtitle != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // El trailing del ListTile toma el ancho que pida, asi que se
                // le pone techo: por encima de un tercio de la pantalla dejaba
                // al titulo sin sitio.
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.34,
                  ),
                  child: Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 16),
              ],
            )
          : trailingWidget,
      onTap: onTap,
    );
  }
}
