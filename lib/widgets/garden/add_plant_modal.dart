import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/widgets/garden/last_watered_sheet.dart';

class AddPlantModal extends StatefulWidget {
  const AddPlantModal({super.key});

  @override
  State<AddPlantModal> createState() => _AddPlantModalState();
}

class _AddPlantModalState extends State<AddPlantModal> {
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  final _nameFocusNode = FocusNode();

  PlantSpecies? _selectedSpecies;
  String _searchQuery = '';
  bool _isSubmitting = false;
  bool _nicknameEditedByUser = false;

  @override
  void initState() {
    super.initState();
    // Sin esto el botón "Añadir planta" no reacciona mientras se escribe
    // (TextEditingController no dispara setState por sí solo).
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_nameController.text.isNotEmpty) _nicknameEditedByUser = true;
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _searchController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _selectSpecies(PlantSpecies species) {
    setState(() {
      _selectedSpecies = species;
      // Sugerencia de nombre a partir de la especie — solo si el usuario
      // no ha escrito nada propio todavía, para no pisar lo que ya puso.
      if (!_nicknameEditedByUser) {
        _nameController.text = species.commonName;
      }
    });
  }

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty && _selectedSpecies != null && !_isSubmitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final nickname = _nameController.text.trim();
    final species = _selectedSpecies!;

    // Preguntamos el último riego antes de crearla, para que el primer
    // recordatorio se cuente desde esa fecha y no desde hoy.
    final answer = await askLastWatered(
      context,
      plantName: species.commonName,
      imageUrl: species.imageUrl,
    );
    if (answer == null || !mounted) return;

    setState(() => _isSubmitting = true);
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    final success = await plantsProvider.addPlant(
      nickname,
      species.id,
      species.commonName,
      lastWateredAt: answer.date,
    );

    if (!mounted) return;

    if (success) {
      final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
      final unlocked =
          await missionsProvider.onPlantAdded(plantsProvider.userPlants.length);
      if (!mounted) return;

      Navigator.of(context).pop();
      showAppToast(
        context,
        AppLocalizations.of(context)!.plantAddedToGarden(nickname),
        type: ToastType.success,
      );
      showAchievementUnlockedSnackbars(context, unlocked);
    } else {
      setState(() => _isSubmitting = false);
      showAppToast(
        context,
        plantsProvider.errorText(context) ?? AppLocalizations.of(context)!.couldNotAddPlant,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    final plantsProvider = Provider.of<PlantsProvider>(context);
    final catalog = plantsProvider.speciesCatalog;
    final filteredCatalog = _searchQuery.isEmpty
        ? catalog
        : catalog.where((sp) {
            final q = _searchQuery.toLowerCase();
            return sp.commonName.toLowerCase().contains(q) ||
                sp.scientificName.toLowerCase().contains(q);
          }).toList();

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ─────────────────────────────────
            const SizedBox(height: 12),
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

            // ── Header ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.addNewPlant,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Name field ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.yourPlantName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.plantNameExample,
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      filled: true,
                      fillColor: const Color(0xFFF5F7F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Species search ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.species,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (_selectedSpecies != null)
                    Text(
                      _selectedSpecies!.commonName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchSpecies,
                          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.textMuted, size: 18),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Species list (scrolls independently so the button below
            // always stays visible, even with 50+ real species) ────────
            Expanded(
              child: _buildSpeciesList(plantsProvider, filteredCatalog),
            ),

            // ── Helper text + submit button ────────────
            Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 16 + safeBottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_canSubmit && !_isSubmitting)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _selectedSpecies == null
                            ? AppLocalizations.of(context)!.pickSpeciesToContinue
                            : AppLocalizations.of(context)!.nameYourPlantToContinue,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: _canSubmit ? _submit : null,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.addPlant,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'Inter',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesList(PlantsProvider plantsProvider, List<PlantSpecies> filteredCatalog) {
    if (plantsProvider.isLoading && plantsProvider.speciesCatalog.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
      );
    }

    if (filteredCatalog.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 32, color: AppColors.textMuted.withValues(alpha: 0.6)),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isEmpty
                    ? AppLocalizations.of(context)!.noSpeciesAvailable
                    : AppLocalizations.of(context)!.noSpeciesFoundFor(_searchQuery),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
      itemCount: filteredCatalog.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final species = filteredCatalog[index];
        final selected = _selectedSpecies?.id == species.id;
        final visual = visualForCategory(species.category);

        return GestureDetector(
          onTap: () => _selectSpecies(species),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFE5EAE7),
                width: selected ? 1.5 : 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: visual.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(visual.icon, color: visual.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        species.commonName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        species.scientificName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected ? AppColors.primary : const Color(0xFFCDD5D1),
                  size: 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
