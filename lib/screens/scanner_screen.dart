import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/utils/catalog_labels.dart';
import 'package:frontend_eco_2/utils/app_tour.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/providers/plants_provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/utils/date_labels.dart';

enum ScannerState { idle, scanning, success, notFound, notConfigured, offline }

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapper for ShowCase
    return Scaffold(
      backgroundColor: Colors.black,
      body: ShowCaseWidget(
        builder: (context) => const ScannerScreenContent(),
      ),
    );
  }
}

class ScannerScreenContent extends StatefulWidget {
  const ScannerScreenContent({super.key});

  @override
  State<ScannerScreenContent> createState() => _ScannerScreenContentState();
}

class _ScannerScreenContentState extends State<ScannerScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;
  
  ScannerState _state = ScannerState.idle;

  // Tour keys
  final GlobalKey _backKey = GlobalKey();
  final GlobalKey _flashKey = GlobalKey();
  final GlobalKey _helpKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _shutterKey = GlobalKey();

  // ── Resultado real de la última identificación ──────────────────────────
  PlantSpecies? _resultSpecies;
  int? _resultConfidencePct;
  // Plant.id reconoció algo, pero esa especie no está en nuestro catálogo
  // — nombre real devuelto por la API, no inventado.
  String? _unmatchedCommonName;
  String? _unmatchedScientificName;
  List<IdentificationAlternate> _alternates = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startTour(BuildContext context) {
    ShowCaseWidget.of(context).startShowCase([
      _backKey,
      _flashKey,
      _historyKey,
      _galleryKey,
      _shutterKey,
    ]);
  }

  Future<void> _pickImageFromGallery() async {
    if (_state == ScannerState.scanning) return;

    // Solicitar permiso de fotos
    await Permission.photos.request();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (image != null) {
      _startScan(image.path);
    }
  }

  /// Identifica la foto en [photoPath] contra la API real de Plant.id
  /// (POST /identifications/fallback). Sin mocks ni resultados simulados —
  /// si algo falla (sin conexión, IA no configurada aún, etc.) se lo
  /// decimos al usuario tal cual es.
  Future<void> _startScan(String photoPath) async {
    setState(() {
      _state = ScannerState.scanning;
      _resultSpecies = null;
      _unmatchedCommonName = null;
      _unmatchedScientificName = null;
      _alternates = [];
    });

    try {
      final bytes = await File(photoPath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final identificationService =
          Provider.of<IdentificationService>(context, listen: false);
      final result = await identificationService.identifyFromPhoto(base64Image);
      if (!mounted) return;

      if (!result.configured) {
        setState(() => _state = ScannerState.notConfigured);
        return;
      }

      if (result.species != null) {
        setState(() {
          _resultSpecies = result.species;
          _resultConfidencePct = ((result.confidenceScore ?? 0) * 100).round();
          _alternates = result.alternates;
          _state = ScannerState.success;
        });
      } else {
        setState(() {
          _unmatchedCommonName = result.unmatchedCommonName;
          _unmatchedScientificName = result.unmatchedScientificName;
          _alternates = result.alternates;
          _state = ScannerState.notFound;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = ScannerState.offline);
      _showOfflineSnackbar();
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted && _state == ScannerState.offline) {
          setState(() => _state = ScannerState.idle);
        }
      });
    }
  }

  void _showOfflineSnackbar() {
    showAppToast(
      context,
      AppLocalizations.of(context)!.identifyConnectionError,
      type: ToastType.error,
    );
  }

  void _onAddToGarden(PlantSpecies species) {
    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
    final bool alreadyExists = plantsProvider.userPlants.any((p) => p.speciesId == species.id);

    if (alreadyExists) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppLocalizations.of(context)!.plantAlreadyRegistered,
              style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
          content: Text(
            AppLocalizations.of(context)!.plantAlreadyRegisteredBody,
            style: const TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.gotIt,
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppLocalizations.of(context)!.addThisPlantQuestion,
              style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.addThisPlantBody,
                  style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.store);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(AppLocalizations.of(context)!.redeemMore,
                        style: const TextStyle(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await plantsProvider.addPlantFromSpecies(species);
                if (success && mounted) {
                  showAppToast(context, AppLocalizations.of(context)!.plantAddedSuccess,
                      type: ToastType.success);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)!.accept, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  void _onViewDetails(PlantSpecies species) {
    Navigator.pushNamed(context, AppRoutes.speciesDetail, arguments: species);
  }

  void _showHistoryModal() {
    final identificationService = Provider.of<IdentificationService>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) {
        return Container(
          height: MediaQuery.of(modalContext).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.scanHistory,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<PlantIdentification>>(
                  future: identificationService.getHistory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.historyLoadFailed,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    final history = snapshot.data ?? [];
                    if (history.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.noScansYet,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, i) {
                        final item = history[i];
                        final species = item.species;
                        final pct = item.confidenceScore != null
                            ? '${(item.confidenceScore! * 100).round()}% de coincidencia'
                            : 'Sin coincidencia';
                        return _buildHistoryItem(
                          species?.commonName ?? 'No identificada',
                          _relativeTime(context, item.createdAt),
                          pct,
                          species == null
                              ? null
                              : () {
                                  Navigator.pop(modalContext);
                                  setState(() {
                                    _resultSpecies = species;
                                    _resultConfidencePct =
                                        ((item.confidenceScore ?? 0) * 100).round();
                                    _alternates = [];
                                    _state = ScannerState.success;
                                  });
                                },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  String _relativeTime(BuildContext context, DateTime dt) {
    final l = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return l.agoMinutes(diff.inMinutes);
    if (diff.inHours < 24) return l.agoHours(diff.inHours);
    if (diff.inDays < 7) return l.agoDays(diff.inDays);
    return formatShortDate(context, dt);
  }

  Widget _buildHistoryItem(String title, String time, String subtitle, VoidCallback? onTap) {
    return Card(
      elevation: 0,
      color: Colors.grey[100], // FIX: Changed to light grey to contrast dark text
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.eco, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.custom(
      saveConfig: SaveConfig.photo(),
      // Configuración de flash para asegurar que solo dispare en captura
      sensorConfig: SensorConfig.single(
        flashMode: FlashMode.auto,
        sensor: Sensor.position(SensorPosition.back),
        zoom: 0.0,
      ),
      builder: (cameraState, preview) {
        return Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildTopControls(context, cameraState),
                  const SizedBox(height: 10),
                  AwesomeZoomSelector(state: cameraState), // Añadido control de zoom
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildScannerFrame(),
                        _buildAnalyzingChip(),
                      ],
                    ),
                  ),
                  if (_state == ScannerState.success)
                    _buildPlantDetailsCard(),
                  if (_state == ScannerState.notFound)
                    _buildNotFoundCard(),
                  if (_state == ScannerState.notConfigured)
                    _buildNotConfiguredCard(),
                  const SizedBox(height: 20),
                  _buildBottomControls(context, cameraState),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopControls(BuildContext context, CameraState cameraState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            key: _backKey,
            tourTitle: 'Volver',
            tourDesc: 'Regresa al panel principal.',
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.pop(context),
          ),
          Row(
            children: [
              _buildControlButton(
                key: _flashKey,
                tourTitle: 'Flash',
                tourDesc: AppLocalizations.of(context)!.flashAutoHint,
                icon: Icons.flash_auto,
                onTap: () {
                  cameraState.sensorConfig.switchCameraFlash();
                },
              ),
              SizedBox(width: 15),
              _buildControlButton(
                key: _helpKey,
                tourTitle: 'Ayuda',
                tourDesc: AppLocalizations.of(context)!.showThisGuide,
                icon: Icons.help_outline,
                onTap: () => _startTour(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required GlobalKey key, 
    required String tourTitle, 
    required String tourDesc, 
    required IconData icon, 
    required VoidCallback onTap
  }) {
    return wrapWithTourStep(
      key: key,
      title: tourTitle,
      description: tourDesc,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildAnalyzingChip() {
    final bool isScanning = _state == ScannerState.scanning;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isScanning 
            ? Container(
                key: const ValueKey('scanning'),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.accent, size: 14),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.analyzing,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                key: const ValueKey('idle'),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.scannerHint,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildScannerFrame() {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        children: [
          _buildCorner(Alignment.topLeft),
          _buildCorner(Alignment.topRight),
          _buildCorner(Alignment.bottomLeft),
          _buildCorner(Alignment.bottomRight),
          if (_state == ScannerState.scanning)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Positioned(
                  top: _scanAnimation.value * 250,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    const double length = 30;
    const double thickness = 3;
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;

    return Align(
      alignment: alignment,
      child: Container(
        width: length,
        height: length,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: AppColors.accent, width: thickness) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: AppColors.accent, width: thickness) : BorderSide.none,
            left: isLeft ? const BorderSide(color: AppColors.accent, width: thickness) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: AppColors.accent, width: thickness) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPlantDetailsCard() {
    final species = _resultSpecies!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.eco, color: AppColors.primary, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            species.commonName,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_resultConfidencePct ?? 0}%',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      species.category != null
                          ? '${species.scientificName} - ${species.category}'
                          : species.scientificName,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTag(species.category ?? 'Planta'),
                        const SizedBox(width: 8),
                        _buildTag(difficultyLabel(
                            context, species.waterFrequencyDays)),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _state = ScannerState.idle),
                child: const Icon(Icons.close, color: Colors.grey, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _onViewDetails(species),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(AppLocalizations.of(context)!.viewSpecSheet,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _onAddToGarden(species),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(AppLocalizations.of(context)!.toMyGarden,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.accent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          if (_alternates.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.otherPossibilities,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (int i = 0; i < _alternates.length && i < 2; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: _buildOtherPossibility(
                      _alternates[i].species,
                      '${(_alternates[i].confidenceScore * 100).round()}%',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Plant.id reconoció algo con confianza aceptable, pero esa especie
  /// todavía no está en nuestro catálogo — se lo decimos tal cual, con el
  /// nombre real que devolvió la API, en vez de forzar un resultado falso.
  Widget _buildNotFoundCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _unmatchedCommonName ?? AppLocalizations.of(context)!.notIdentified,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_unmatchedScientificName != null)
                      Text(
                        _unmatchedScientificName!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _state = ScannerState.idle),
                child: const Icon(Icons.close, color: Colors.grey, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _unmatchedCommonName != null
                ? AppLocalizations.of(context)!.scannerNotInCatalog
                : AppLocalizations.of(context)!.scannerLowConfidence,
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  /// El backend aún no tiene PLANT_ID_API_KEY configurada.
  Widget _buildNotConfiguredCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome_outlined, color: AppColors.primary, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.aiNotAvailable,
              style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _state = ScannerState.idle),
            child: const Icon(Icons.close, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9E3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOtherPossibility(PlantSpecies species, String percentage) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DEC9),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      species.commonName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      percentage,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _onViewDetails(species),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 24),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(AppLocalizations.of(context)!.view,
                      style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _onAddToGarden(species),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 24),
                    backgroundColor: AppColors.accent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(AppLocalizations.of(context)!.add, style: const TextStyle(fontSize: 10, color: AppColors.primaryDark)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, CameraState cameraState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          wrapWithTourStep(
            key: _galleryKey,
            title: AppLocalizations.of(context)!.gallery,
            description: AppLocalizations.of(context)!.tourGalleryDescription,
            child: GestureDetector(
              onTap: _pickImageFromGallery,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          wrapWithTourStep(
            key: _shutterKey,
            title: AppLocalizations.of(context)!.shutter,
            description: AppLocalizations.of(context)!.tourShutterDescription,
            child: GestureDetector(
              onTap: () {
                if (_state == ScannerState.scanning) return;
                cameraState.when(
                  onPhotoMode: (photoState) async {
                    final captureRequest = await photoState.takePhoto();
                    final path = captureRequest.path;
                    if (path == null) {
                      _showOfflineSnackbar();
                      return;
                    }
                    _startScan(path);
                  },
                );
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          wrapWithTourStep(
            key: _historyKey,
            title: AppLocalizations.of(context)!.history,
            description: AppLocalizations.of(context)!.tourHistoryDesc,
            child: GestureDetector(
              onTap: _showHistoryModal,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.star,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
