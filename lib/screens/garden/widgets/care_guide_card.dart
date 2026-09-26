import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/utils/app_tour.dart';
import 'package:frontend_eco_2/utils/care_task_labels.dart';
import 'species_data.dart';

/// Tarjeta de orientación: a diferencia de [SpeciesCareGrid] (datos crudos:
/// frecuencia, temperatura, luz...) esto traduce esos datos a lenguaje
/// llano — dónde ubicar la planta y cómo regarla — para alguien que recién
/// la agregó y no sabe por dónde empezar.
class CareGuideCard extends StatelessWidget {
  final SpeciesData sp;
  // Solo se pasa desde PlantDetailScreen para el tour de "cómo cuidar esta
  // planta" — señala específicamente el mini-calendario de abajo.
  final GlobalKey? scheduleKey;

  const CareGuideCard({super.key, required this.sp, this.scheduleKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates_rounded, size: 18, color: Color(0xFF10454F)),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.howToCareForYourPlant,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF0D2B31),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _hintRow(Icons.wb_sunny_rounded, const Color(0xFFB8860B), sp.placementHint),
          const SizedBox(height: 14),
          Text(
            sp.careGuide,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3A534E),
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          wrapWithTourStep(
            key: scheduleKey,
            title: AppLocalizations.of(context)!.careCalendar,
            description: AppLocalizations.of(context)!.tourCareCalendarDesc,
            child: _buildSchedule(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whenToDoEachCare,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF0D2B31),
            fontFamily: 'Inter',
          ),
        ),
        SizedBox(height: 8),
        _scheduleRow(context, 'watering', AppLocalizations.of(context)!.careEveryNDays(sp.waterFreqDays)),
        _scheduleRow(context, 'fertilizing', AppLocalizations.of(context)!.scheduleFertilizing),
        _scheduleRow(context, 'pruning', AppLocalizations.of(context)!.schedulePruning),
        _scheduleRow(context, 'repotting', AppLocalizations.of(context)!.scheduleRepotting),
      ],
    );
  }

  Widget _scheduleRow(BuildContext context, String taskType, String schedule) {
    final visual = careTaskVisual(taskType);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(visual.icon, size: 14, color: visual.color),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              careTaskLabel(context, taskType),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D2B31),
                fontFamily: 'Inter',
              ),
            ),
          ),
          Expanded(
            child: Text(
              schedule,
              style: const TextStyle(fontSize: 12, color: Color(0xFF3A534E), fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hintRow(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D2B31),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
