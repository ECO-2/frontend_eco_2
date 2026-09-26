import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

/// Equivalencias del CO₂ acumulado por el jardín del usuario.
///
/// Antes esta tarjeta mostraba "12 Árboles", "480 Horas" y "150 Kilómetros"
/// escritos a mano — los mismos para cualquiera, y además el widget ni
/// siquiera se usaba en ninguna pantalla. Ahora se calculan a partir del CO₂
/// real que devuelve `GET /user/green-footprint`.
///
/// FACTORES DE CONVERSIÓN (aproximados, documentados para poder revisarlos):
///  - Coche: 120 g CO₂/km — media de turismo de gasolina.
///  - Bombilla LED: 9 W durante 1 h = 0,009 kWh; a ~400 g CO₂/kWh de mezcla
///    eléctrica media da 3,6 g CO₂/h.
///  - Árbol: un ejemplar adulto fija del orden de 21 kg CO₂/año ≈ 57,5 g/día.
///    Por eso se expresa en "días de un árbol" y no en número de árboles: con
///    los valores reales de un jardín de interior, contar árboles enteros
///    daría siempre cero.
///
/// Son estimaciones de divulgación, no una medición. La tarjeta lo indica.
class ImpactEquivalentsCard extends StatelessWidget {
  /// CO₂ total acumulado por el jardín, en gramos.
  final double totalGrams;

  const ImpactEquivalentsCard({super.key, required this.totalGrams});

  static const _gramsPerKmCar = 120.0;
  static const _gramsPerHourLed = 3.6;
  static const _gramsPerTreeDay = 57.5;

  /// Formatea sin decimales inútiles: 0,03 se ve como "0.03", 12 como "12".
  String _fmt(double v) {
    if (v >= 100) return v.toStringAsFixed(0);
    if (v >= 10) return v.toStringAsFixed(1);
    return v.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Un jardín recién creado tiene ~0 g acumulados: mostrar "0.00 km" parece
    // un fallo. Se dice explícitamente que todavía no da para una comparación.
    final tooSmall = totalGrams < 1;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECE9), width: 1.5),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.yourImpactEquals,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 20),
          if (tooSmall)
            Text(
              l.impactTooSmall,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
                height: 1.4,
              ),
            )
          else ...[
            _buildImpactRow(
              icon: Icons.directions_car_outlined,
              iconBg: const Color(0xFFFDF1EB),
              iconColor: AppColors.orange,
              title: l.impactCarTitle(_fmt(totalGrams / _gramsPerKmCar)),
              subtitle: l.impactCarSubtitle,
            ),
            const SizedBox(height: 16),
            _buildImpactRow(
              icon: Icons.lightbulb_outline_rounded,
              iconBg: const Color(0xFFFEF9E7),
              iconColor: AppColors.gold,
              title: l.impactBulbTitle(_fmt(totalGrams / _gramsPerHourLed)),
              subtitle: l.impactBulbSubtitle,
            ),
            const SizedBox(height: 16),
            _buildImpactRow(
              icon: Icons.park_outlined,
              iconBg: const Color(0xFFEAF5EA),
              iconColor: Colors.green,
              title: l.impactTreeTitle(_fmt(totalGrams / _gramsPerTreeDay)),
              subtitle: l.impactTreeSubtitle,
            ),
          ],
          const SizedBox(height: 16),
          Text(
            l.impactApproxNote,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
