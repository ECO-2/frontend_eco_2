import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/utils/app_tour.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/plant_visuals.dart';
import 'package:frontend_eco_2/utils/cloudinary_transform.dart';
import 'package:frontend_eco_2/utils/top_clamping_scroll_physics.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';
import 'package:frontend_eco_2/widgets/common/custom_bottom_nav_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';

// Import components from widgets/
import 'widgets/species_data.dart';
import 'widgets/care_sheet_content.dart';
import 'widgets/care_status_card.dart';
import 'widgets/care_guide_card.dart';
import 'widgets/species_care_grid.dart';
import 'widgets/care_history_list.dart';
import 'widgets/plant_photo_viewer.dart';
import 'package:frontend_eco_2/utils/date_labels.dart';
import 'package:frontend_eco_2/routing/tab_navigation.dart';

// Legacy mock species (s1-s3) keep their curated SpeciesData entry; every
// real catalog species (real UUID from the backend) gets one built from its
// actual fields instead of falling back to the same generic placeholder.
SpeciesData _resolveSpeciesData(
  BuildContext context,
  String speciesId, {
  PlantSpecies? embedded,
}) {
  // La especie que viene embebida con la planta es la fuente más fiable:
  // llega siempre con la respuesta del backend, incluso si el catálogo
  // todavía no ha terminado de cargar.
  if (embedded != null) return SpeciesData.fromReal(context, embedded);

  final species = _resolveRealSpecies(context, speciesId);
  return SpeciesData.fromReal(context, species);
}

/// Especie real del catálogo (para navegar a SpeciesDetailScreen, que espera
/// un [PlantSpecies] completo). Para las 3 especies legacy (s1-s3, sin fila
/// real en el catálogo) se sintetiza una a partir de su [SpeciesData]
/// curada, para que "ver ficha completa" funcione también con ellas.
PlantSpecies _resolveRealSpecies(BuildContext context, String speciesId) {
  final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
  final found = plantsProvider.speciesCatalog.where((s) => s.id == speciesId);
  if (found.isNotEmpty) return found.first;

  return PlantSpecies(
    id: speciesId,
    scientificName: 'Especie desconocida',
    commonName: 'Planta',
    waterFrequencyDays: 7,
    createdAt: DateTime.now(),
  );
}

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plant = ModalRoute.of(context)?.settings.arguments as UserPlant?;
    if (plant == null) {
      return Scaffold(
          body: Center(child: Text(AppLocalizations.of(context)!.plantNotFound)));
    }

    return ShowCaseWidget(
      // Sin esto el recorrido no se movia: los pasos 3 y 4 (registrar cuidado
      // y ficha de la especie) quedan debajo del pliegue y showcaseview trae
      // `enableAutoScroll` en false por defecto, asi que resaltaba un punto
      // fuera de pantalla y parecia que el recorrido se colgaba.
      enableAutoScroll: true,
      scrollDuration: const Duration(milliseconds: 400),
      onFinish: () {
        Provider.of<SecureStorage>(context, listen: false).markPlantCareTourSeen();
      },
      builder: (context) => _PlantDetailBody(plant: plant),
    );
  }
}

class _PlantDetailBody extends StatefulWidget {
  final UserPlant plant;

  const _PlantDetailBody({required this.plant});

  @override
  State<_PlantDetailBody> createState() => _PlantDetailBodyState();
}

class _PlantDetailBodyState extends State<_PlantDetailBody> {
  final _tourKeys = PlantCareTourKeys();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  Future<void> _maybeStartTour() async {
    if (!mounted) return;
    final storage = Provider.of<SecureStorage>(context, listen: false);
    final seen = await storage.hasSeenPlantCareTour();
    if (seen || !mounted) return;
    ShowCaseWidget.of(context).startShowCase(_tourKeys.orderedSteps);
  }

  void _restartTour() {
    ShowCaseWidget.of(context).startShowCase(_tourKeys.orderedSteps);
  }

  @override
  Widget build(BuildContext context) {
    final plantsProvider = Provider.of<PlantsProvider>(context);
    // Toma la versión más reciente (apodo recién editado, etc.) si sigue en
    // la colección; si no la encuentra (ej. se acaba de eliminar) usa la que
    // llegó por argumento para no romper la pantalla.
    final plant = plantsProvider.userPlants.firstWhere(
      (p) => p.id == widget.plant.id,
      orElse: () => widget.plant,
    );
    final sp = _resolveSpeciesData(context, plant.speciesId, embedded: plant.species);
    final customPhoto = plantsProvider.customPhotoFor(plant.id);

    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = 64.0;
    const imageHeight = 200.0;
    const imageWidth = double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          // ── CAPA 1: Imagen fija en el fondo ──
          Positioned(
            top: statusBarHeight + appBarHeight + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: imageWidth,
                      height: imageHeight,
                      // Sin foto: fondo de color de la especie, para que el ícono
                      // resalte. Con foto (propia o real): sin fondo —
                      // transparente — y BoxFit.contain, para que se vea
                      // completa, sin recortarla ni deformarla.
                      color: (customPhoto != null || sp.imageUrl != null) ? Colors.transparent : sp.bg,
                      padding: (customPhoto != null || sp.imageUrl != null)
                          ? const EdgeInsets.all(12)
                          : EdgeInsets.zero,
                      child: customPhoto != null
                          ? Image.file(customPhoto, fit: BoxFit.contain, width: double.infinity)
                          : sp.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: withTransparentBackground(sp.imageUrl!),
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  placeholder: (_, _) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (_, _, _) => Icon(
                                    sp.placeholderIcon,
                                    size: 80,
                                    color: sp.placeholderIconColor.withValues(alpha: 0.6),
                                  ),
                                )
                              : sp.assetImage != null
                                  ? Image.asset(sp.assetImage!, fit: BoxFit.contain)
                                  : Icon(
                                      sp.placeholderIcon,
                                      size: 80,
                                      color: sp.placeholderIconColor.withValues(alpha: 0.6),
                                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── CAPA 2: Contenido desplazable (sobre la imagen) ──
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const TopClampingScrollPhysics(),
              child: Column(
                children: [
                  // Espacio transparente para mostrar la imagen fija del fondo
                  // al principio. El botón de la foto vive AQUÍ y no sobre la
                  // imagen: esta capa es un Positioned.fill con un scroll que
                  // cubre toda la pantalla, así que se quedaba con todos los
                  // toques y el botón de abajo nunca reaccionaba.
                  SizedBox(
                    height: statusBarHeight + appBarHeight + imageHeight + 24,
                    child: Stack(
                      children: [
                        // Toque sobre la zona de la imagen para verla de cerca.
                        // Va aquí y no sobre la propia imagen porque esa capa
                        // está debajo del scroll y no recibe toques.
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => showPlantPhoto(
                              context,
                              customPhoto: customPhoto,
                              imageUrl: sp.imageUrl,
                              title: plant.nickname.isNotEmpty
                                  ? plant.nickname
                                  : plant.name,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          bottom: 20,
                          child: GestureDetector(
                            onTap: () => _choosePhoto(
                              context,
                              plant.id,
                              hasCustomPhoto: customPhoto != null,
                            ),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 18,
                                color: Color(0xFF0D2B31),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Caja contenedora sólida del detalle
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      24,
                      24,
                      120,
                    ), // Padding inferior amplio para el BottomNavBar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Plant Title & Acquisition Info ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          plant.nickname,
                                          style: const TextStyle(
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            color: Color(0xFF0D2B31),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () => _editNickname(context, plant),
                                        child: const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Icon(
                                            Icons.edit_rounded,
                                            size: 18,
                                            color: Color(0xFF807F7F),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    sp.scientific,
                                    style: const TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontSize: 14,
                                      color: Color(0xFF807F7F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.inMyCollectionSince,
                                  style: const TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontSize: 11,
                                    color: Color(0xFF807F7F),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  plant.acquiredAt == null
                                      ? '—'
                                      : formatMediumDate(
                                          context, plant.acquiredAt!),
                                  style: const TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF0D2B31),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── Tags ──
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: sp.tags.map((tag) {
                            final style = styleForTagKind(tag.kind);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: style.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(style.icon, size: 12, color: style.color),
                                  const SizedBox(width: 5),
                                  Text(
                                    tag.text,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: style.color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Divider(
                          color: Color(0xFFE2E7E4),
                          height: 1,
                          thickness: 1,
                        ),
                        SizedBox(height: 20),

                        // ── Care Status Card ──
                        wrapWithTourStep(
                          key: _tourKeys.statusCard,
                          title: AppLocalizations.of(context)!.wateringStatus,
                          description:
                              AppLocalizations.of(context)!.tourWateringStatusDesc,
                          child: CareStatusCard(plant: plant, sp: sp),
                        ),
                        const SizedBox(height: 20),

                        // ── Care Guide (orientación: dónde ubicarla y cómo cuidarla) ──
                        CareGuideCard(sp: sp, scheduleKey: _tourKeys.schedule),
                        const SizedBox(height: 24),

                        // ── Action Buttons ──
                        Row(
                          children: [
                            Expanded(
                              child: wrapWithTourStep(
                                key: _tourKeys.registerButton,
                                title: AppLocalizations.of(context)!.logEveryCare,
                                description:
                                    AppLocalizations.of(context)!.tourLogCareDesc,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D2B31),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () => _showCareSheet(context, plant),
                                  icon: const Icon(
                                    Icons.water_drop_rounded,
                                    size: 18,
                                    color: Color.fromARGB(255, 236, 233, 21),
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!.logCare,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0D2B31),
                                  side: const BorderSide(
                                    color: Color(0xFF0D2B31),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.careHistory,
                                    arguments: plant,
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.viewHistory,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── Section: Últimos cuidados ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.latestCare,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0D2B31),
                                fontFamily: 'Inter',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.careHistory,
                                arguments: plant,
                              ),
                              child: Row(
                                children: [
                                  Text(AppLocalizations.of(context)!.viewAll,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF807F7F),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: Color(0xFF807F7F),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        FutureBuilder<List<CareLog>>(
                          future: Provider.of<CareService>(context, listen: false)
                              .getCareLogs(plant.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2.5),
                                  ),
                                ),
                              );
                            }
                            return CareHistoryList(logs: snapshot.data ?? const []);
                          },
                        ),
                        const SizedBox(height: 24),

                        _RemindersMutedTile(plant: plant),
                        const SizedBox(height: 24),

                        // ── Section: Cuidados de la especie ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.speciesCare,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0D2B31),
                                fontFamily: 'Inter',
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.speciesDetail,
                                arguments: plant.species ?? _resolveRealSpecies(context, plant.speciesId),
                              ),
                              child: Row(
                                children: [
                                  Text(AppLocalizations.of(context)!.viewFullSheet,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF807F7F),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: Color(0xFF807F7F),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        wrapWithTourStep(
                          key: _tourKeys.speciesGrid,
                          title: AppLocalizations.of(context)!.speciesSpecSheet,
                          description: AppLocalizations.of(context)!.tourSpeciesGridDesc,
                          child: SpeciesCareGrid(sp: sp),
                        ),
                        const SizedBox(height: 24),

                        // ── Section: Mi nota personal ──
                        Text(AppLocalizations.of(context)!.myPersonalNote,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF0D2B31),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF5E4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF8C9682),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            sp.personalNote,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0D2B31),
                              fontFamily: 'Inter',
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── CAPA 3: Custom Status Bar (al frente) ──
          const Positioned(top: 0, left: 0, right: 0, child: CustomStatusBar()),

          // ── CAPA 4: Custom AppBar (al frente y fija) ──
          // Traslúcido con desenfoque: deja ver un poco de lo que hay
          // detrás (imagen o contenido al hacer scroll) en vez de un
          // bloque blanco sólido fijo.
          Positioned(
            top: statusBarHeight,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.55),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F5F4).withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Color(0xFF0D2B31),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.myGarden,
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF0D2B31),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.help_outline_rounded,
                          color: Color(0xFF0D2B31),
                          size: 24,
                        ),
                        tooltip: AppLocalizations.of(context)!.howToCareForThisPlant,
                        onPressed: _restartTour,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1, // Jardín
        onTap: (index) {
          // Jardin vuelve atras, porque el detalle se abrio desde ahi; el
          // resto va a la pestaña pedida del dashboard.
          if (index == 1) {
            Navigator.pop(context);
            return;
          }
          openDashboardTab(context, index);
        },
      ),
    );
  }

  // ── Editar apodo ─────────────────────────────────────────────────────
  Future<void> _editNickname(BuildContext context, UserPlant plant) async {
    final controller = TextEditingController(text: plant.nickname);
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);

    final newNickname = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editNickname),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.plantNicknameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );

    if (newNickname == null || newNickname.trim() == plant.nickname || !context.mounted) return;

    final ok = await plantsProvider.updateNickname(plant.id, newNickname);
    if (!context.mounted) return;
    showAppToast(
      context,
      ok
          ? AppLocalizations.of(context)!.nicknameUpdated
          : (plantsProvider.errorText(context) ??
              AppLocalizations.of(context)!.nicknameUpdateFailed),
      type: ok ? ToastType.success : ToastType.error,
    );
  }

  // ── Elegir foto de la planta (se guarda solo en este dispositivo) ──────
  Future<void> _choosePhoto(BuildContext context, String plantId, {required bool hasCustomPhoto}) async {
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);

    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded, color: Color(0xFF0D2B31)),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () => Navigator.pop(sheetContext, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: Color(0xFF0D2B31)),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () => Navigator.pop(sheetContext, 'gallery'),
            ),
            if (hasCustomPhoto)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.removePhoto,
                    style: const TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(sheetContext, 'remove'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (choice == null) return;

    if (choice == 'remove') {
      await plantsProvider.removeCustomPhoto(plantId);
      if (context.mounted) {
        showAppToast(context, AppLocalizations.of(context)!.photoRemoved, type: ToastType.success);
      }
      return;
    }

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked == null) return; // El usuario canceló, no es un error.

      await plantsProvider.setCustomPhoto(plantId, picked.path);
      if (context.mounted) {
        showAppToast(context, AppLocalizations.of(context)!.photoUpdated, type: ToastType.success);
      }
    } catch (_) {
      // Permiso de cámara/galería denegado, u otro fallo del selector.
      if (context.mounted) {
        showAppToast(
          context,
          AppLocalizations.of(context)!.cameraPermissionError,
          type: ToastType.error,
        );
      }
    }
  }

  void _showCareSheet(BuildContext context, UserPlant plant) {
    final sp = _resolveSpeciesData(context, plant.speciesId, embedded: plant.species);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return CareSheetContent(plant: plant, sp: sp);
      },
    );
  }

}

/// Interruptor para silenciar los recordatorios de una sola planta.
///
/// Es distinto del interruptor global de Ajustes: aquí se apagan los avisos de
/// ESTA planta y el resto del jardín sigue avisando. El backend excluye las
/// plantas silenciadas al buscar tareas vencidas, así que no se envía nada —
/// no es un filtro cosmético en la app.
class _RemindersMutedTile extends StatelessWidget {
  final UserPlant plant;

  const _RemindersMutedTile({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    final muted = plant.remindersMuted;
    final name = plant.nickname.isNotEmpty ? plant.nickname : plant.name;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E7E4)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Icon(
            muted
                ? Icons.notifications_off_rounded
                : Icons.notifications_active_rounded,
            size: 20,
            color: muted ? const Color(0xFF807F7F) : const Color(0xFF0D2B31),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.muteReminders,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF0D2B31),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  muted ? l.muteRemindersOn : l.muteRemindersOff,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF807F7F),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: muted,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE2E7E4),
            onChanged: (value) async {
              final ok =
                  await plantsProvider.setRemindersMuted(plant.id, value);
              if (!context.mounted) return;
              showAppToast(
                context,
                ok
                    ? (value
                        ? l.remindersMuted(name)
                        : l.remindersUnmuted(name))
                    : (plantsProvider.errorText(context) ?? l.connectionError),
                type: ok ? ToastType.success : ToastType.error,
              );
            },
          ),
        ],
      ),
    );
  }
}
