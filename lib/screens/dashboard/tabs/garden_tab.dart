import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/achievement_feedback.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/utils/catalog_labels.dart';
import 'package:frontend_eco_2/utils/cloudinary_transform.dart';
import 'package:frontend_eco_2/utils/watering_status.dart';
import 'package:frontend_eco_2/utils/pot_labels.dart';
import 'package:frontend_eco_2/widgets/garden/rental_pot_banner.dart';
import 'package:frontend_eco_2/widgets/garden/last_watered_sheet.dart';
import 'package:frontend_eco_2/widgets/garden/needs_water_badge.dart';
import 'package:frontend_eco_2/widgets/garden/add_plant_modal.dart';
import 'package:frontend_eco_2/screens/garden/widgets/needs_care_modal.dart';
import 'package:frontend_eco_2/widgets/common/tag_chips_row.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

// ── Figma color tokens ────────────────────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);

// Categorías rápidas para el filtro de "Mi Jardín" — mismas categorías
// reales del catálogo (reemplaza el filtro anterior "Interior/Exterior" que
// era una aproximación heurística sobre categorías que no encajan del todo).
const _kGardenQuickCategories = ['tropical', 'succulent', 'cactus'];

class GardenTab extends StatefulWidget {
  const GardenTab({super.key});

  @override
  State<GardenTab> createState() => _GardenTabState();
}

class _GardenTabState extends State<GardenTab> {
  String _searchQuery = '';
  bool _isGridView = false;
  bool _isGardenGridView = false;
  String _selectedGardenCategory = 'all';

  // Catalog filters. Category/light store the raw API enum value (or
  // 'all'); difficulty stores the exact label PlantSpecies.difficulty
  // returns (or 'Todas').
  String _selectedCategoryValue = 'all';
  String _selectedDifficulty = 'all';
  String _selectedLight = 'all';

  final TextEditingController _searchController = TextEditingController();

  // Quick-access chips show only the most common categories; the rest are
  // reachable from the full filter sheet (tune button).
  static const List<String> _quickCategoryKeys = ['succulent', 'tropical', 'cactus'];
  static const List<String> _allCategoryKeys = [
    'tropical',
    'succulent',
    'cactus',
    'fern',
    'flowering',
    'herb',
    'tree',
    'other',
  ];
  // Claves estables, no etiquetas: el texto visible se traduce, así que
  // comparar contra él rompería el filtro al cambiar de idioma.
  static const List<String> _difficultyOptions = ['all', 'very_easy', 'easy', 'medium'];
  static const List<String> _lightKeys = ['low', 'medium', 'high', 'indirect'];

  bool get _hasAdvancedFilters => _selectedDifficulty != 'all' || _selectedLight != 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Agrega [species] al jardín del usuario y, si tuvo éxito, otorga XP real
  /// y revisa logros de tipo `user_plants` — usado por los botones rápidos
  /// "Añadir" del catálogo (a diferencia de AddPlantModal, que hace lo mismo
  /// pero con selección de apodo).
  Future<void> _addSpeciesToGarden(
    BuildContext context,
    PlantSpecies species,
    PlantsProvider plantsProvider,
  ) async {
    // Preguntamos el último riego ANTES de crearla: el backend programa el
    // primer recordatorio desde esa fecha, así que una planta que el usuario
    // ya venía cuidando no espera un ciclo completo de más.
    final answer = await askLastWatered(
      context,
      plantName: species.commonName,
      imageUrl: species.imageUrl,
    );
    if (answer == null) return; // cerró la hoja: no damos de alta nada
    if (!context.mounted) return;

    final success = await plantsProvider.addPlantFromSpecies(
      species,
      lastWateredAt: answer.date,
    );
    if (!context.mounted) return;

    if (!success) {
      showAppToast(
        context,
        plantsProvider.errorText(context) ??
            AppLocalizations.of(context)!.plantAddFailed,
        type: ToastType.error,
      );
      return;
    }

    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    final unlocked = await missionsProvider.onPlantAdded(plantsProvider.userPlants.length);
    if (!context.mounted) return;

    showAppToast(context,
        AppLocalizations.of(context)!.plantAddedToGarden(species.commonName),
        type: ToastType.success);
    showAchievementUnlockedSnackbars(context, unlocked);
  }

  // Legacy mock species (s1-s5) keep their bespoke background/illustration;
  // every real catalog species (real UUID from the backend) gets a
  // category-based visual instead of a single generic placeholder.
  Color _getSpeciesBg(String id, {String? category}) {
    switch (id) {
      case 's1':
        return const Color(0xFFF2F7F2);
      case 's2':
        return const Color(0xFFEAF5EA);
      case 's3':
        return const Color(0xFFF0F4EC);
      case 's4':
        return const Color(0xFFEAF0E8);
      case 's5':
        return const Color(0xFFF5F2E8);
      default:
        return visualForCategory(category).background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    final plants = plantsProvider.userPlants;
    final showCatalog = plantsProvider.showCatalogTab;

    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row (Title & Toggle) ─────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  showCatalog
                      ? AppLocalizations.of(context)!.navGarden
                      : AppLocalizations.of(context)!.myGarden,
                  style: const TextStyle(
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: _kTextDark,
                  ),
                ),
                // Pill Toggle Selector
                //
                // Antes cada mitad era su propio AnimatedContainer: al cambiar,
                // una se apagaba y la otra se encendia a la vez, y eso se leia
                // como un parpadeo. Ahora hay una sola pastilla que se desliza
                // de un lado al otro, y el color del texto se interpola.
                _GardenToggle(
                  showCatalog: showCatalog,
                  onChanged: plantsProvider.setShowCatalogTab,
                ),
              ],
            ),
          ),

          // Render view based on toggle
          Expanded(
            // El contenido tambien se cruza con una transicion corta en vez de
            // reemplazarse de golpe.
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                final slide = Tween<Offset>(
                  // Entra desde el lado al que corresponde: el catalogo desde
                  // la izquierda, Mi Jardin desde la derecha.
                  begin: Offset(child.key == const ValueKey('catalog') ? -0.04 : 0.04, 0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: showCatalog
                  ? KeyedSubtree(
                      key: const ValueKey('catalog'),
                      child: _buildCatalogView(context, plantsProvider),
                    )
                  : KeyedSubtree(
                      key: const ValueKey('my_garden'),
                      child:
                          _buildMyGardenView(context, plantsProvider, plants),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogView(BuildContext context, PlantsProvider plantsProvider) {
    final catalog = plantsProvider.speciesCatalog;
    final filteredCatalog = catalog.where((species) {
      final matchesSearch = species.commonName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          species.scientificName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategoryValue == 'all' || species.category == _selectedCategoryValue;
      final matchesDifficulty =
          _selectedDifficulty == 'all' ||
          difficultyKey(species.waterFrequencyDays) == _selectedDifficulty;
      final matchesLight = _selectedLight == 'all' || species.lightRequirement == _selectedLight;
      return matchesSearch && matchesCategory && matchesDifficulty && matchesLight;
    }).toList();

    // "Tendencias": no hay datos de popularidad/analítica en el backend, así
    // que se usan las especies con mejor puntaje real de purificación de
    // aire (air_purification_score) como criterio honesto de destacadas.
    final trends = [...catalog]
      ..sort((a, b) => (b.airPurificationScore ?? 0).compareTo(a.airPurificationScore ?? 0));
    final topTrends = trends.take(5).toList();
    final showTrends = _searchQuery.isEmpty && _selectedCategoryValue == 'all' && !_hasAdvancedFilters;

    // A single real scrollable (CustomScrollView + SliverGrid/SliverList)
    // instead of a ListView.builder/GridView.builder nested with
    // shrinkWrap+NeverScrollableScrollPhysics inside an outer ListView.
    // shrinkWrap forces Flutter to lay out every item up front to measure
    // the shrink-wrapped extent, defeating lazy building — with 50+ catalog
    // cards that meant all of them were built (images, badges, buttons)
    // even though only ~4 are ever visible. Slivers keep this lazy no
    // matter how large the catalog grows, with no pagination/"load more"
    // UI needed.
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildCatalogSearchBar()),
        SliverToBoxAdapter(child: _buildCatalogFilterChips()),
        if (showTrends) SliverToBoxAdapter(child: _buildTrendsSection(context, topTrends)),
        SliverToBoxAdapter(child: _buildExplorarHeader(filteredCatalog.length)),
        if (filteredCatalog.isEmpty)
          SliverToBoxAdapter(child: _buildEmptyCatalogState())
        else if (_isGridView)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildGridCatalogCard(context, filteredCatalog[index], plantsProvider),
                childCount: filteredCatalog.length,
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildListCatalogCard(context, filteredCatalog[index], plantsProvider),
                childCount: filteredCatalog.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildCatalogSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF1EF),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: _kTextMuted, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchMyPlant,
                        hintStyle: const TextStyle(
                          color: _kTextMuted,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Icon(Icons.close_rounded, color: _kTextMuted, size: 18),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Circular search icon button
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
            ),
            child: const Icon(Icons.search_rounded, color: _kDark, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildQuickCategoryChip('Todas', 'all'),
                  ..._quickCategoryKeys.map(
                    (key) => _buildQuickCategoryChip(categoryLabel(context, key), key),
                  ),
                ],
              ),
            ),
            // Filter icon button — opens the full filter sheet (category,
            // difficulty, light).
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => _openFilterSheet(context),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: _hasAdvancedFilters ? _kDark : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _hasAdvancedFilters ? _kDark : const Color(0xFFE5EAE7),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: _hasAdvancedFilters ? Colors.white : _kDark,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCategoryChip(String label, String value) {
    final selected = _selectedCategoryValue == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategoryValue = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _kDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _kDark : const Color(0xFFE5EAE7),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: selected ? Colors.white : _kTextDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendsSection(BuildContext context, List<PlantSpecies> topTrends) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.trendingThisWeek,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _kTextDark,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 255,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: topTrends.length,
            itemBuilder: (context, idx) {
              final species = topTrends[idx];
              final visual = visualForCategory(species.category);
              final purificationScore = species.airPurificationScore ?? 0;
              final commonNameText = species.commonName;
              final subtitleText = species.scientificName;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.speciesDetail,
                    arguments: species,
                  );
                },
                child: Container(
                  width: 165,
                  margin: const EdgeInsets.only(right: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container with purification badge
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              // Sin foto: fondo de color de la categoría, para que el ícono
                              // resalte. Con foto real: sin fondo — totalmente
                              // transparente — y BoxFit.contain, para que se vea
                              // completa y sin recortes ni deformación.
                              color: species.imageUrl != null
                                  ? Colors.transparent
                                  : _getSpeciesBg(species.id, category: species.category),
                              alignment: Alignment.center,
                              child: species.imageUrl != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: CachedNetworkImage(
                                        imageUrl: withTransparentBackground(species.imageUrl!),
                                        fit: BoxFit.contain,
                                        placeholder: (_, _) => const Center(
                                          child: SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ),
                                        errorWidget: (_, _, _) => Icon(
                                          visual.icon,
                                          size: 48,
                                          color: visual.color.withValues(alpha: 0.4),
                                        ),
                                      ),
                                    )
                                  : species.id == 's1'
                                      ? Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Image.asset('assets/images/monstera.png', fit: BoxFit.contain),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(
                                            visual.icon,
                                            size: 48,
                                            color: visual.color.withValues(alpha: 0.4),
                                          ),
                                        ),
                            ),
                            // Floating purification badge (real air_purification_score)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.air_rounded,
                                  color: Colors.orange,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Details
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commonNameText,
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: _kTextDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitleText,
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 11,
                                color: _kTextMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F4EB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    difficultyLabel(context, species.waterFrequencyDays),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: _kDark,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.air_rounded,
                                        color: Colors.orange, size: 10),
                                    const SizedBox(width: 2),
                                    Text(
                                      '$purificationScore/9',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: _kTextDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExplorarHeader(int resultCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.exploreSpecies,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _kTextDark,
            ),
          ),
          Row(
            children: [
              Text(
                '$resultCount plantas',
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  color: _kTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              // Grid/List toggle button
              GestureDetector(
                onTap: () => setState(() => _isGridView = !_isGridView),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                  ),
                  child: Icon(
                    _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    size: 16,
                    color: _kDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCatalogState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: _kTextMuted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.noSpeciesMatchFilters,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: _kTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    String tempCategory = _selectedCategoryValue;
    String tempDifficulty = _selectedDifficulty;
    String tempLight = _selectedLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            Widget sectionTitle(String text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _kTextDark,
                    ),
                  ),
                );

            Widget filterChip(String label, bool selected, VoidCallback onTap) {
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? _kDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? _kDark : const Color(0xFFE5EAE7),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: selected ? Colors.white : _kTextDark,
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E7E4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.filters,
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _kTextDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setSheetState(() {
                          tempCategory = 'all';
                          tempDifficulty = 'all';
                          tempLight = 'all';
                        }),
                        child: Text(AppLocalizations.of(context)!.clear,
                          style: TextStyle(color: _kTextMuted, fontFamily: 'Inter'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  sectionTitle(AppLocalizations.of(context)!.category),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      filterChip('Todas', tempCategory == 'all',
                          () => setSheetState(() => tempCategory = 'all')),
                      ..._allCategoryKeys.map(
                        (key) => filterChip(
                          categoryLabel(context, key),
                          tempCategory == key,
                          () => setSheetState(() => tempCategory = key),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  sectionTitle('Dificultad'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _difficultyOptions
                        .map(
                          (option) => filterChip(
                            difficultyOptionLabel(context, option),
                            tempDifficulty == option,
                            () => setSheetState(() => tempDifficulty = option),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  sectionTitle('Luz'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      filterChip('Todas', tempLight == 'all',
                          () => setSheetState(() => tempLight = 'all')),
                      ..._lightKeys.map(
                        (key) => filterChip(
                          lightLabel(context, key),
                          tempLight == key,
                          () => setSheetState(() => tempLight = key),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kDark,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedCategoryValue = tempCategory;
                          _selectedDifficulty = tempDifficulty;
                          _selectedLight = tempLight;
                        });
                        Navigator.pop(sheetContext);
                      },
                      child: Text(AppLocalizations.of(context)!.applyFilters,
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListCatalogCard(BuildContext context, PlantSpecies species, PlantsProvider plantsProvider) {
    final isMonstera = species.id == 's1';
    final visual = visualForCategory(species.category);
    final nameToDisplay = species.commonName;
    final subtitleToDisplay = species.scientificName;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.speciesDetail,
          arguments: species,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image container (left)
              Container(
                width: 110,
                color: species.imageUrl != null
                    ? Colors.transparent
                    : _getSpeciesBg(species.id, category: species.category),
                child: species.imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: CachedNetworkImage(
                          imageUrl: withTransparentBackground(species.imageUrl!),
                          fit: BoxFit.contain,
                          placeholder: (_, _) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, _, _) => Icon(
                            visual.icon,
                            size: 40,
                            color: visual.color.withValues(alpha: 0.4),
                          ),
                        ),
                      )
                    : isMonstera
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/images/monstera.png', fit: BoxFit.contain),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              visual.icon,
                              size: 40,
                              color: visual.color.withValues(alpha: 0.4),
                            ),
                          ),
              ),
              // Details container (right)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nameToDisplay,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _kTextDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleToDisplay,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          color: _kTextMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Difficulty (fijo) + tags de la especie en una sola
                      // línea con scroll horizontal — nunca se apilan a una
                      // segunda línea ni empujan el resto de la tarjeta.
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4EB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              difficultyLabel(context, species.waterFrequencyDays),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: _kDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TagChipsRow(
                              tags: speciesTags(
                                context,
                                category: species.category,
                                lightRequirement: species.lightRequirement,
                                waterFrequencyDays: species.waterFrequencyDays,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Add Button
                      GestureDetector(
                        onTap: () => _addSpeciesToGarden(context, species, plantsProvider),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBDE038), // Lime Green
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 14, color: _kTextDark),
                              SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.add,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _kTextDark,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCatalogCard(BuildContext context, PlantSpecies species, PlantsProvider plantsProvider) {
    final isMonstera = species.id == 's1';
    final visual = visualForCategory(species.category);
    final nameToDisplay = species.commonName;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.speciesDetail,
          arguments: species,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: species.imageUrl != null
                    ? Colors.transparent
                    : _getSpeciesBg(species.id, category: species.category),
                alignment: Alignment.center,
                child: species.imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: CachedNetworkImage(
                          imageUrl: withTransparentBackground(species.imageUrl!),
                          fit: BoxFit.contain,
                          placeholder: (_, _) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, _, _) => Icon(
                            visual.icon,
                            size: 40,
                            color: visual.color.withValues(alpha: 0.4),
                          ),
                        ),
                      )
                    : isMonstera
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/images/monstera.png', fit: BoxFit.contain),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              visual.icon,
                              size: 40,
                              color: visual.color.withValues(alpha: 0.4),
                            ),
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameToDisplay,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _kTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    species.scientificName,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  ...[
                    TagChipsRow(
                      tags: speciesTags(
                        context,
                        category: species.category,
                        lightRequirement: species.lightRequirement,
                        waterFrequencyDays: species.waterFrequencyDays,
                      ).take(2).toList(),
                      fontSize: 8,
                      iconSize: 9,
                    ),
                    const SizedBox(height: 6),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4EB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          difficultyLabel(context, species.waterFrequencyDays),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: _kDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addSpeciesToGarden(context, species, plantsProvider),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFBDE038),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 14, color: _kTextDark),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _needsWater(UserPlant p, PlantsProvider plantsProvider) {
    final species = plantsProvider.speciesCatalog.firstWhere(
      (s) => s.id == p.speciesId,
      orElse: () => catalogFallback(p.speciesId),
    );
    // Mismo cálculo que la ficha de detalle (WateringStatus), para que la
    // tarjeta y el detalle no puedan volver a contradecirse.
    return WateringStatus.of(p, species.waterFrequencyDays).needsWater;
  }

  Widget _buildMyGardenView(BuildContext context, PlantsProvider plantsProvider, List<UserPlant> plants) {
    // Filtro por categoría real de especie (mismo criterio que el catálogo),
    // en vez de la aproximación Interior/Exterior anterior.
    final filteredPlants = plants.where((p) {
      if (_selectedGardenCategory == 'all') return true;
      final info = plantsProvider.speciesCatalog.firstWhere(
        (s) => s.id == p.speciesId,
        orElse: () => catalogFallback(p.speciesId),
      );
      return info.category == _selectedGardenCategory;
    }).toList();

    // Plants that need watering
    final plantsNeedingWater = plants.where((p) => _needsWater(p, plantsProvider)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Filter chips ──
        _buildGardenFilterChips(),

        // ── Alert Banner ──
        if (plantsNeedingWater.isNotEmpty)
          _buildAttentionBanner(context, plantsNeedingWater.length),

        // El alquiler corre desde que se paga, asi que se mantiene a la vista
        // mientras dure: si no, el usuario solo se entera cuando le falta
        // sitio, que es cuando ya no puede hacer nada.
        RentalPotBanner(
          onUseSlot: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddPlantModal(),
          ),
        ),

        // ── Plants list/grid ──
        Expanded(
          child: filteredPlants.isEmpty
              ? _buildEmptyGardenState(context, plants.length)
              : _isGardenGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredPlants.length + 1,
                      itemBuilder: (context, i) {
                        if (i == filteredPlants.length) {
                          return _buildAddPlantButton(context, plants.length);
                        }
                        final plant = filteredPlants[i];
                        return _PlantGridCard(
                          plant: plant,
                          species: plantsProvider.speciesCatalog.firstWhere(
                            (s) => s.id == plant.speciesId,
                            orElse: () => catalogFallback(plant.speciesId),
                          ),
                          customPhoto: plantsProvider.customPhotoFor(plant.id),
                          needsWater: _needsWater(plant, plantsProvider),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.plantDetail,
                            arguments: plant,
                          ),
                          onDelete: () => plantsProvider.deletePlant(plant.id),
                        );
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 12, bottom: 100),
                      children: [
                        ...filteredPlants.map((plant) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PlantListCard(
                                plant: plant,
                                species: plantsProvider.speciesCatalog.firstWhere(
                                  (s) => s.id == plant.speciesId,
                                  orElse: () => catalogFallback(plant.speciesId),
                                ),
                                customPhoto: plantsProvider.customPhotoFor(plant.id),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.plantDetail,
                                  arguments: plant,
                                ),
                                onWater: () => plantsProvider.waterPlant(plant.id),
                                onDelete: () => plantsProvider.deletePlant(plant.id),
                              ),
                            )),
                        // Add plant button at the bottom
                        const SizedBox(height: 8),
                        _buildAddPlantButton(context, plants.length),
                      ],
                    ),
        ),
      ],
    );
  }

  Widget _buildEmptyGardenState(BuildContext context, int totalPlantCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        children: [
          Icon(Icons.eco_outlined, size: 40, color: _kTextMuted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.noPlantsInCategory,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: _kTextMuted),
          ),
          const SizedBox(height: 16),
          _buildAddPlantButton(context, totalPlantCount),
        ],
      ),
    );
  }

  PlantSpecies catalogFallback(String speciesId) {
    return PlantSpecies(
      id: speciesId,
      scientificName: 'Especie desconocida',
      commonName: 'Planta',
      waterFrequencyDays: 7,
      createdAt: DateTime.now(),
    );
  }

  Widget _buildGardenFilterChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildGardenCategoryChip('Todas', 'all'),
                  ..._kGardenQuickCategories.map(
                    (key) => _buildGardenCategoryChip(categoryLabel(context, key), key),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _openGardenCategorySheet(context),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                  ),
                  child: const Icon(Icons.tune_rounded, color: _kDark, size: 18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => setState(() => _isGardenGridView = !_isGardenGridView),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
                  ),
                  child: Icon(
                    _isGardenGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    color: _kDark,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGardenCategoryChip(String label, String value) {
    final selected = _selectedGardenCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedGardenCategory = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? _kDark : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? _kDark : const Color(0xFFE5EAE7),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: selected ? Colors.white : _kTextDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openGardenCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E7E4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.filterByCategory,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _kTextDark,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildGardenCategoryChip('Todas', 'all'),
                  ..._allCategoryKeys.map(
                    (key) => _buildGardenCategoryChip(categoryLabel(context, key), key),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    ).then((_) => setState(() {}));
  }

  Widget _buildAttentionBanner(BuildContext context, int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5D9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD3E0B5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: _kDark, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 13),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.needsAttentionToday(count),
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: _kTextDark,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showNeedsCareModal(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kDark, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.view,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _kTextDark,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 13, color: _kTextDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPlantButton(BuildContext context, int plantCount) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AddPlantModal(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _DashedCornerPainter(color: Color(0xFF8FA89F)),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '+',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: _kDark,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF8FA89F),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: _kDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppLocalizations.of(context)!.addPlant,
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _kTextDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      potsCaption(context,
                          context.watch<PlanProvider>().status, plantCount),
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 11,
                        color: Color(0xFF8FA89F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCornerPainter extends CustomPainter {
  final Color color;
  const _DashedCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final double r = 16.0; // Corner radius
    final double l = 8.0;  // Extension length
    final double w = size.width;
    final double h = size.height;

    final path = Path();

    // Top-left
    path.moveTo(r + l, 0);
    path.lineTo(r, 0);
    path.arcToPoint(Offset(0, r), radius: Radius.circular(r), clockwise: false);
    path.lineTo(0, r + l);

    // Top-right
    path.moveTo(w - (r + l), 0);
    path.lineTo(w - r, 0);
    path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w, r + l);

    // Bottom-left
    path.moveTo(0, h - (r + l));
    path.lineTo(0, h - r);
    path.arcToPoint(Offset(r, h), radius: Radius.circular(r), clockwise: false);
    path.lineTo(r + l, h);

    // Bottom-right
    path.moveTo(w, h - (r + l));
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r), clockwise: true);
    path.lineTo(w - (r + l), h);

    _drawDashedPath(canvas, path, paint, 3.0, 3.0);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLength, double gapLength) {
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final length = dashLength;
        final drawLength = (distance + length < pathMetric.length) ? length : pathMetric.length - distance;
        canvas.drawPath(pathMetric.extractPath(distance, distance + drawLength), paint);
        distance += length + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCornerPainter oldDelegate) => color != oldDelegate.color;
}

// ── Species data (mirrors plant_card.dart) ───────────────────────────────────
// _kSpeciesData (mocks s1-s5) eliminado: sus IDs no existen en el
// catálogo real, que usa UUID.

class _GardenSpecies {
  final String scientificName;
  final List<SpeciesTag> tags;
  final Color imageBg;
  final String? assetImage;
  final String? imageUrl;
  final IconData placeholderIcon;
  final Color placeholderIconColor;
  const _GardenSpecies({
    required this.scientificName,
    required this.tags,
    required this.imageBg,
    this.assetImage,
    this.imageUrl,
    this.placeholderIcon = Icons.local_florist_rounded,
    this.placeholderIconColor = AppColors.primary,
  });

  // Real catalog species (real UUID from the backend) don't have a legacy
  // illustration, but they do have a real photo (imageUrl) — use that, and
  // fall back to a category-based icon/color only if it's missing.
  factory _GardenSpecies.fromReal(BuildContext context, PlantSpecies species) {
    final visual = visualForCategory(species.category);
    return _GardenSpecies(
      scientificName: species.scientificName,
      tags: speciesTags(
        context,
        category: species.category,
        lightRequirement: species.lightRequirement,
        waterFrequencyDays: species.waterFrequencyDays,
      ),
      imageBg: visual.background,
      imageUrl: species.imageUrl,
      placeholderIcon: visual.icon,
      placeholderIconColor: visual.color,
    );
  }
}

// ── Swipe-to-delete — compartido entre la tarjeta de lista y de cuadrícula ──

Widget _buildDeleteBackground(BuildContext context, {double borderRadius = 20}) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: const Color(0xFFD32F2F),
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
        const SizedBox(width: 8),
        Text(AppLocalizations.of(context)!.delete,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ),
  );
}

/// Solo confirma la intención de borrar — nunca hace la llamada de red
/// aquí. Si el borrado se disparara desde confirmDismiss y la operación de
/// red tardara, el widget quedaría en un estado intermedio raro; en vez de
/// eso, la eliminación real ocurre en onDismissed, una vez que la animación
/// de swipe ya terminó.
Future<bool> _confirmDelete(BuildContext context, String nickname) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(AppLocalizations.of(dialogContext)!.deletePlantTitle),
      content: Text(
          AppLocalizations.of(dialogContext)!.deletePlantBody(nickname)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(AppLocalizations.of(dialogContext)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(AppLocalizations.of(dialogContext)!.delete, style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Ejecuta el borrado ya confirmado (después de que la animación de swipe
/// terminó). PlantsProvider.deletePlant ya quita la planta de la lista
/// local antes de llamar a la API, así que si falla la restaura y avisa
/// con un toast — sin dejar el Dismissible en un estado inconsistente.
Future<void> _runDelete(BuildContext context, Future<bool> Function() onDelete) async {
  final success = await onDelete();
  if (!success && context.mounted) {
    showAppToast(context, AppLocalizations.of(context)!.plantDeleteFailed,
        type: ToastType.error);
  }
}

// ── Plant list card — Mi Jardín horizontal ────────────────────────────────────
class _PlantListCard extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final File? customPhoto;
  final VoidCallback onTap;
  final VoidCallback onWater;
  final Future<bool> Function() onDelete;

  const _PlantListCard({
    required this.plant,
    required this.species,
    this.customPhoto,
    required this.onTap,
    required this.onWater,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final status = WateringStatus.of(plant, species.waterFrequencyDays);
    final neverWatered = status.neverWatered;
    final needsWater = status.needsWater;
    final sp = _GardenSpecies.fromReal(context, species);

    // Status pill — siempre con ícono de check (estilo Figma), el color y el
    // texto reflejan el estado real: días exactos sin riego cuando ya toca,
    // "Al día" cuando no.
    final statusBg = needsWater ? const Color(0xFFFFF4EC) : const Color(0xFFF2F4EB);
    final statusBorderColor = needsWater ? const Color(0xFFFFCCA0) : const Color(0xFF8A9A65);
    final statusTextColor = needsWater ? const Color(0xFFB94E13) : const Color(0xFF10454F);
    final overdueBy = status.daysOverdue;
    final l = AppLocalizations.of(context)!;
    final statusText = !needsWater
        ? (neverWatered ? l.noWateringYet : l.upToDate)
        : overdueBy <= 0
            ? l.wateringToday
            : l.daysOverdueLabel(overdueBy);
    const statusIcon = Icons.check_rounded;

    final daysLabel = neverWatered
        ? l.noWateringLoggedEvery(species.waterFrequencyDays)
        : l.daysWithoutWaterEvery(
            status.daysSinceReference, species.waterFrequencyDays);

    return MediaQuery(
      // Bloquea el escalado de fuente del sistema solo para esta tarjeta —
      // con "Texto grande" activado en accesibilidad, el texto podría crecer
      // más de lo que el alto fijo de la tarjeta admite y volver a desbordar.
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Dismissible(
      key: ValueKey('plant-list-${plant.id}'),
      direction: DismissDirection.startToEnd,
      background: _buildDeleteBackground(context),
      confirmDismiss: (_) => _confirmDelete(context, plant.nickname),
      onDismissed: (_) => _runDelete(context, onDelete),
      child: GestureDetector(
      onTap: onTap,
      child: Container(
        // Alto fijo — antes se calculaba con IntrinsicHeight según el
        // contenido de texto, así que las tarjetas quedaban de altura
        // dispareja. Con un alto fijo todas quedan parejas, y la imagen
        // (que se estira a lo alto de la tarjeta) puede ser más grande.
        height: 176,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE5EAE7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              // ── LEFT CONTAINER: Image box ─────────────────────────
              Container(
                width: 152,
                decoration: BoxDecoration(
                  // Sin foto propia: fondo de color de la especie. Con foto
                  // (propia o real): sin fondo — transparente — para que
                  // quede uniforme y el contain no deje ver color detrás.
                  color: (customPhoto != null || sp.imageUrl != null) ? Colors.transparent : sp.imageBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5E7A82),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Image — foto propia del usuario > foto real de la especie >
                    // ilustración local heredada > ícono. BoxFit.contain para que
                    // la foto se vea completa siempre, sin recortarla ni deformarla.
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.5),
                        child: customPhoto != null
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.file(customPhoto!, fit: BoxFit.contain),
                              )
                            : sp.assetImage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      sp.assetImage!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => Icon(
                                        sp.placeholderIcon,
                                        size: 48,
                                        color: sp.placeholderIconColor.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  )
                                : sp.imageUrl != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CachedNetworkImage(
                                          imageUrl: withTransparentBackground(sp.imageUrl!),
                                          fit: BoxFit.contain,
                                          placeholder: (_, _) => const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          ),
                                          errorWidget: (_, _, _) => Icon(
                                            sp.placeholderIcon,
                                            size: 48,
                                            color: sp.placeholderIconColor.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          sp.placeholderIcon,
                                          size: 48,
                                          color: sp.placeholderIconColor.withValues(alpha: 0.5),
                                        ),
                                      ),
                      ),
                    ),
                    // Cartel de riego — solo cuando de verdad hace falta.
                    Positioned(
                      top: 6,
                      right: 6,
                      child: NeedsWaterBadge(needsWater: needsWater),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // ── RIGHT CONTAINER: Info column ────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title + Chevron
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            plant.nickname,
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: _kTextDark,
                            ),
                            // Una sola línea — con 2 el alto del texto podía
                            // superar el alto fijo de la tarjeta (overflow).
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 22,
                          color: _kTextDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Scientific name
                    Text(
                      sp.scientificName,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: _kTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Status Row (Status Pill + Days Label)
                    // Fila y no Wrap: con la app en ingles la etiqueta de
                    // dias es mas larga, el Wrap saltaba a una segunda linea y
                    // la tarjeta, que tiene alto fijo, se desbordaba por abajo.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: statusBorderColor,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 12,
                                color: statusTextColor,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  statusText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: statusTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            daysLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF807F7F),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tags Row — una sola línea con scroll horizontal, no se
                    // apila ni deforma la tarjeta sin importar cuántos tags
                    // tenga la especie.
                    TagChipsRow(
                      tags: sp.tags,
                      fontSize: 10,
                      iconSize: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      ),
      ),
    );
  }

}

// ── Plant grid card — Mi Jardín en cuadrícula ──────────────────────────────
class _PlantGridCard extends StatelessWidget {
  final UserPlant plant;
  final PlantSpecies species;
  final File? customPhoto;
  final bool needsWater;
  final VoidCallback onTap;
  final Future<bool> Function() onDelete;

  const _PlantGridCard({
    required this.plant,
    required this.species,
    this.customPhoto,
    required this.needsWater,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final visual = visualForCategory(species.category);

    return MediaQuery(
      // Misma protección que en la tarjeta de lista: la celda de la
      // cuadrícula ya es de tamaño fijo (GridView), así que un texto más
      // grande por accesibilidad no debe poder desbordarla.
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Dismissible(
      key: ValueKey('plant-grid-${plant.id}'),
      direction: DismissDirection.startToEnd,
      background: _buildDeleteBackground(context, borderRadius: 20),
      confirmDismiss: (_) => _confirmDelete(context, plant.nickname),
      onDismissed: (_) => _runDelete(context, onDelete),
      child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5EAE7), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: (customPhoto != null || species.imageUrl != null)
                        ? Colors.transparent
                        : visual.background,
                    alignment: Alignment.center,
                    child: customPhoto != null
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.file(customPhoto!, fit: BoxFit.contain),
                          )
                        : species.imageUrl != null
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: CachedNetworkImage(
                                  imageUrl: withTransparentBackground(species.imageUrl!),
                                  fit: BoxFit.contain,
                                  placeholder: (_, _) => const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (_, _, _) => Icon(
                                    visual.icon,
                                    size: 40,
                                    color: visual.color.withValues(alpha: 0.5),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(visual.icon, size: 40, color: visual.color.withValues(alpha: 0.5)),
                              ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: NeedsWaterBadge(needsWater: needsWater, compact: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.nickname,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: _kTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    species.scientificName,
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}

/// Interruptor Jardín / Mi Jardín con una pastilla que se desliza.
///
/// La versión anterior pintaba dos `AnimatedContainer` independientes: al
/// cambiar, uno perdía el fondo y el otro lo ganaba en el mismo instante, lo
/// que se percibía como un parpadeo en lugar de un movimiento.
class _GardenToggle extends StatelessWidget {
  final bool showCatalog;
  final ValueChanged<bool> onChanged;

  const _GardenToggle({required this.showCatalog, required this.onChanged});

  static const _duration = Duration(milliseconds: 260);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: IntrinsicWidth(
        child: Stack(
          children: [
            // La pastilla ocupa media fila y se alinea a un extremo u otro,
            // así que la anchura se adapta sola al texto de cada idioma.
            Positioned.fill(
              child: AnimatedAlign(
                duration: _duration,
                curve: _curve,
                alignment:
                    showCatalog ? Alignment.centerLeft : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _kDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _half(context, l.navGarden, selected: showCatalog, value: true),
                _half(context, l.myGarden, selected: !showCatalog, value: false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _half(BuildContext context, String label,
      {required bool selected, required bool value}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: AnimatedDefaultTextStyle(
            duration: _duration,
            curve: _curve,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: selected ? Colors.white : _kTextMuted,
            ),
            child: Text(label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
