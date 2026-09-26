import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/widgets/common/custom_button.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/utils/date_labels.dart';

// ── Mock identification result ────────────────────────────────────────────
class _ScanResult {
  final String commonName;
  final String scientificName;
  final int confidencePct;
  final List<String> tags;
  final String speciesId;

  const _ScanResult({
    required this.commonName,
    required this.scientificName,
    required this.confidencePct,
    required this.tags,
    required this.speciesId,
  });
}

const _mockResult = _ScanResult(
  commonName: 'Monstera',
  scientificName: 'Monstera deliciosa',
  confidencePct: 98,
  tags: ['Tropical', 'Luz indirecta', 'Riego semanal'],
  speciesId: 's1',
);

// ── ScannerTab ────────────────────────────────────────────────────────────
class ScannerTab extends StatefulWidget {
  const ScannerTab({super.key});

  @override
  State<ScannerTab> createState() => _ScannerTabState();
}

class _ScannerTabState extends State<ScannerTab> {
  bool _showResult = false;
  bool _scanning = false;

  void _triggerScan() async {
    // Navigate to the new full-screen ScannerScreen
    Navigator.pushNamed(context, AppRoutes.scan);
  }

  void _resetScan() => setState(() => _showResult = false);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _showResult
          ? _ResultView(
              result: _mockResult,
              onReset: _resetScan,
            )
          : _ViewfinderView(
              scanning: _scanning,
              onScan: _triggerScan,
            ),
    );
  }
}

// ── Viewfinder View ────────────────────────────────────────────────────────
class _ViewfinderView extends StatelessWidget {
  final bool scanning;
  final VoidCallback onScan;

  const _ViewfinderView({required this.scanning, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.plantIdentification,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.scannerTabHint,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 20),

          // Viewfinder Card
          GestureDetector(
            onTap: onScan,
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Stack(
                  children: [
                    // Background colour
                    Container(color: AppColors.primaryDark),
                    // Subtle plant illustration
                    Center(
                      child: Icon(
                        Icons.local_florist_rounded,
                        size: 90,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    // Corner brackets
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: _corner(top: true, left: true),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: _corner(top: true, left: false),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: _corner(top: false, left: true),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: _corner(top: false, left: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Laser line animation
                    const Positioned.fill(child: _ScanningLaserLine()),
                    // Status tag at bottom
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                scanning
                                    ? 'Analizando…'
                                    : 'Toca para Escanear',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Loading overlay
                    if (scanning)
                      Container(
                        color: Colors.black.withValues(alpha: 0.35),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 3,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: AppLocalizations.of(context)!.takePhotoAction,
                  icon: Icons.camera_alt,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: onScan,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: AppLocalizations.of(context)!.uploadFromGallery,
                  icon: Icons.photo_library,
                  isOutlined: true,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: onScan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent analyses
          Text(
            AppLocalizations.of(context)!.recentAnalyses,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          // Historial real (GET del servicio de identificacion). Antes habia
          // dos entradas inventadas fijas -- "Monstera 98% hace 2 horas" y
          // "Poto 94% ayer" -- iguales para todo el mundo, escaneara o no.
          FutureBuilder<List<PlantIdentification>>(
            future: Provider.of<IdentificationService>(context, listen: false)
                .getHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              final history = snapshot.data ?? const <PlantIdentification>[];
              if (history.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)!.noScansYet,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (final item in history.take(3)) ...[
                    _buildRecentItem(
                      item.species?.commonName ??
                          AppLocalizations.of(context)!.notIdentified,
                      item.confidenceScore == null
                          ? ''
                          : AppLocalizations.of(context)!
                              .matchPercent((item.confidenceScore! * 100).round()),
                      formatShortDate(context, item.createdAt),
                      Icons.eco,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _corner({required bool top, required bool left}) {
    return SizedBox(
      width: 24,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? const BorderSide(color: AppColors.accent, width: 3)
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(color: AppColors.accent, width: 3)
                : BorderSide.none,
            left: left
                ? const BorderSide(color: AppColors.accent, width: 3)
                : BorderSide.none,
            right: !left
                ? const BorderSide(color: AppColors.accent, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentItem(
      String title, String subtitle, String time, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.textMuted.withValues(alpha: 0.15),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
        trailing: Text(time,
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 11)),
      ),
    );
  }
}

// ── Result View ──────────────────────────────────────────────────────────
class _ResultView extends StatelessWidget {
  final _ScanResult result;
  final VoidCallback onReset;

  const _ResultView({required this.result, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          left: 16, right: 16, top: 16, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back / header row
          Row(
            children: [
              GestureDetector(
                onTap: onReset,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(AppLocalizations.of(context)!.newScan,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Result card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                // Plant image area (green header)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCEDDC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_florist_rounded,
                    size: 80,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Confidence badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.matchPercent(result.confidencePct),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Names
                      Text(
                        result.commonName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.scientificName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: result.tags
                            .map((t) => _buildTag(t))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons (Figma: "Ver ficha" and "+ A mi jardín")
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  label: Text(AppLocalizations.of(context)!.viewSpecSheet,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onPressed: () {
                    final plantsProvider = Provider.of<PlantsProvider>(context, listen: false);
                    final species = plantsProvider.speciesCatalog.firstWhere(
                      (s) => s.id == result.speciesId,
                      orElse: () => PlantSpecies(
                        id: result.speciesId,
                        scientificName: result.scientificName,
                        commonName: result.commonName,
                        waterFrequencyDays: 7,
                        createdAt: DateTime.now(),
                      ),
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.speciesDetail,
                      arguments: species,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: Text(
                    AppLocalizations.of(context)!.toMyGarden,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  onPressed: () {
                    Provider.of<PlantsProvider>(context, listen: false)
                        .addPlant(result.commonName, result.speciesId, result.commonName);
                    showAppToast(
                      context,
                      AppLocalizations.of(context)!.plantAddedToGarden(result.commonName),
                      type: ToastType.success,
                    );
                    onReset();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

// ── Laser line animation ──────────────────────────────────────────────────
class _ScanningLaserLine extends StatefulWidget {
  const _ScanningLaserLine();

  @override
  State<_ScanningLaserLine> createState() => _ScanningLaserLineState();
}

class _ScanningLaserLineState extends State<_ScanningLaserLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment(0, (_controller.value * 2) - 1),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.0),
                  AppColors.accent,
                  AppColors.accent,
                  AppColors.accent.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
