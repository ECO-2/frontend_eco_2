import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'species_data.dart';
import 'package:frontend_eco_2/utils/date_labels.dart';

// El tipo de cuidado se guarda ya con el valor que espera el backend (enum
// TaskType de Prisma). Antes se guardaba la etiqueta visible en español y un
// mapa la traducía: con la app en inglés la clave no existía y reventaba.

/// Etiqueta visible de un tipo de cuidado.
String careTypeLabel(BuildContext context, String taskType) {
  final l = AppLocalizations.of(context)!;
  switch (taskType) {
    case 'fertilizing':
      return l.careTypeFertilizing;
    case 'pruning':
      return l.careTypePruning;
    case 'repotting':
      return l.careTypeRepotting;
    default:
      return l.careTypeWatering;
  }
}

class CareSheetContent extends StatefulWidget {
  final UserPlant plant;
  final SpeciesData sp;

  const CareSheetContent({
    super.key,
    required this.plant,
    required this.sp,
  });

  @override
  State<CareSheetContent> createState() => _CareSheetContentState();
}

class _CareSheetContentState extends State<CareSheetContent> {
  String _selectedType = 'watering';
  String _selectedDateOption = 'Hoy';
  DateTime _customDate = DateTime.now();
  final TextEditingController _noteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    
    // Calculate suggestion date based on base date
    DateTime baseDate = DateTime.now();
    if (_selectedDateOption == 'Ayer') {
      baseDate = DateTime.now().subtract(const Duration(days: 1));
    } else if (_selectedDateOption == 'Otra fecha') {
      baseDate = _customDate;
    }
    
    final nextDate = baseDate.add(Duration(days: widget.sp.waterFreqDays));
    final daysDiff = nextDate.difference(DateTime.now()).inDays;
    
    String daysText;
    if (daysDiff == 0) {
      daysText = AppLocalizations.of(context)!.today.toLowerCase();
    } else if (daysDiff == 1) {
      daysText = AppLocalizations.of(context)!.inOneDay;
    } else if (daysDiff < 0) {
      daysText = AppLocalizations.of(context)!.daysAgoShort(-daysDiff);
    } else {
      daysText = AppLocalizations.of(context)!.inNDays(daysDiff);
    }
    
    final nextDateStr = formatMediumDate(context, nextDate);
    final nextSuggestedCareText = "$nextDateStr · $daysText";

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle top bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.logCare,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF0D2B31),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.plant.nickname} · ${widget.sp.scientific}',
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 13,
                            color: Color(0xFF807F7F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F5F4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF0D2B31),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Tipo de cuidado label
              Text(
                AppLocalizations.of(context)!.careType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0D2B31),
                ),
              ),
              const SizedBox(height: 12),
              
              // Care options grid
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      type: 'watering',
                      icon: Icons.water_drop_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFEAF3FC),
                      inactiveIconColor: const Color(0xFF4A90D9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeCard(
                      type: 'fertilizing',
                      icon: Icons.grain_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFEFF5E4),
                      inactiveIconColor: const Color(0xFF8A9A65),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      type: 'pruning',
                      icon: Icons.content_cut_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFFFF0EC),
                      inactiveIconColor: const Color(0xFFF56B1C),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeCard(
                      type: 'repotting',
                      icon: Icons.upload_rounded,
                      activeBgColor: const Color(0xFF164650),
                      inactiveIconBgColor: const Color(0xFFF0F2F1),
                      inactiveIconColor: const Color(0xFF808E89),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Fecha label
              Text(AppLocalizations.of(context)!.date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0D2B31),
                ),
              ),
              const SizedBox(height: 12),
              
              // Date options row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDateButton('Hoy'),
                  _buildDateButton('Ayer'),
                  _buildDateButton('Otra fecha'),
                ],
              ),
              const SizedBox(height: 24),
              
              // Nota label
              Text(AppLocalizations.of(context)!.noteOptional,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0D2B31),
                ),
              ),
              const SizedBox(height: 12),
              
              // Note TextField
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEFF1F0),
                  hintText: AppLocalizations.of(context)!.careNoteHint,
                  hintStyle: const TextStyle(color: Color(0xFF9CA59E), fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: const TextStyle(color: Color(0xFF0D2B31), fontSize: 14),
              ),
              const SizedBox(height: 24),
              
              // Suggested care card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5D9),
                  border: Border.all(color: const Color(0xFFD3E0B5), width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF3A534E),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.suggestedNextWatering,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7E8A83),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nextSuggestedCareText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF0D2B31),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Guardar / Registrar Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2B31),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF0D2B31).withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _isSubmitting ? null : () => _submit(plantsProvider),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(AppLocalizations.of(context)!.logCare,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(PlantsProvider plantsProvider) async {
    setState(() => _isSubmitting = true);

    DateTime finalDate = DateTime.now();
    if (_selectedDateOption == 'Ayer') {
      finalDate = DateTime.now().subtract(const Duration(days: 1));
    } else if (_selectedDateOption == 'Otra fecha') {
      finalDate = _customDate;
    }

    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final unlocked = await missionsProvider.logCare(
      userPlantId: widget.plant.id,
      taskType: _selectedType,
    );

    if (unlocked == null) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      showAppToast(
        context,
        missionsProvider.errorText(context) ??
            AppLocalizations.of(context)!.careLogFailed,
        type: ToastType.error,
      );
      return;
    }

    // El riego además actualiza last_watered_at, que es lo que mueve el
    // badge "necesita riego" en el resto de la app.
    if (_selectedType == 'watering') {
      await plantsProvider.waterPlant(widget.plant.id, date: finalDate);
    }

    if (!mounted) return;
    Navigator.pop(context);
    showAppToast(
        context,
        AppLocalizations.of(context)!.careLoggedToast(careTypeLabel(context, _selectedType)),
        type: ToastType.success);
    showAchievementUnlockedSnackbars(context, unlocked);
  }

  Widget _buildTypeCard({
    required String type,
    required IconData icon,
    required Color activeBgColor,
    required Color inactiveIconBgColor,
    required Color inactiveIconColor,
  }) {
    final isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF265E6B) : inactiveIconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : inactiveIconColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                careTypeLabel(context, type),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? Colors.white : const Color(0xFF0D2B31),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(String option) {
    final isSelected = _selectedDateOption == option;
    
    return GestureDetector(
      onTap: () async {
        if (option == 'Otra fecha') {
          final picked = await showDatePicker(
            context: context,
            initialDate: _customDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF0D2B31),
                    onPrimary: Colors.white,
                    onSurface: Color(0xFF0D2B31),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              _customDate = picked;
              _selectedDateOption = option;
            });
          }
        } else {
          setState(() {
            _selectedDateOption = option;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D2B31) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
        ),
        child: Text(
          option,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSelected ? Colors.white : const Color(0xFF5A6F6C),
          ),
        ),
      ),
    );
  }
}
