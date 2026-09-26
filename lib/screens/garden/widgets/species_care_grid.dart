import 'package:flutter/material.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'species_data.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

class SpeciesCareGrid extends StatelessWidget {
  final SpeciesData sp;

  const SpeciesCareGrid({
    super.key,
    required this.sp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCareGridCard(
                icon: Icons.water_drop_outlined,
                iconColor: const Color(0xFF4A90D9),
                label: AppLocalizations.of(context)!.watering,
                value: sp.waterFreq,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCareGridCard(
                icon: Icons.wb_sunny_outlined,
                iconColor: const Color(0xFFFABF2E),
                label: AppLocalizations.of(context)!.lightLabelShort,
                value: sp.light,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCareGridCard(
                icon: Icons.thermostat_outlined,
                iconColor: const Color(0xFFF56B1C),
                label: AppLocalizations.of(context)!.tempShort,
                value: sp.temp,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCareGridCard(
                icon: Icons.opacity_rounded,
                iconColor: const Color(0xFF00796B),
                label: AppLocalizations.of(context)!.humidityLabelShort,
                value: sp.humidity,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCareGridCard(
                icon: Icons.eco_outlined,
                iconColor: AppColors.primary,
                label: AppLocalizations.of(context)!.o2co2,
                value: sp.co2,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  Widget _buildCareGridCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7E4), width: 1.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF807F7F),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0D2B31),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
