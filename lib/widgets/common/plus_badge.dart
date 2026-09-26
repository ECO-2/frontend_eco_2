import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Insignia de miembro O2+.
///
/// Se muestra solo cuando la suscripción está activa de verdad: el backend
/// comprueba `plan_type` y la fecha de fin juntos, así que una suscripción
/// caducada deja de mostrarla sola.
class PlusBadge extends StatelessWidget {
  /// Compacta: solo el símbolo, para ir junto a un nombre.
  final bool compact;

  const PlusBadge({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, Color(0xFF9BC22B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: compact ? 11 : 13,
            color: AppColors.primaryDark,
          ),
          SizedBox(width: compact ? 3 : 5),
          Text(
            'O₂₊',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: compact ? 10 : 12,
              fontFamily: 'DM Sans',
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
