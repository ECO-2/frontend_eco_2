import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/widgets/profile/impact_equivalents.dart';

// ── Color tokens extracted from Figma ────────────────────────────────────
const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kLime = Color(0xFFBDE038);
const _kBarBg = Color(0xFFF0F0F0);

/// "Mi Huella Verde".
///
/// Toda la pantalla estaba con datos escritos a mano ("36.5 g/día", tres
/// plantas de ejemplo y una serie semanal inventada), iguales para cualquier
/// usuario. Ahora se pide al backend (`GET /user/green-footprint`), que calcula
/// el CO₂ a partir de las plantas reales del usuario y del valor por especie
/// cargado en el catálogo.
class GreenFootprintScreen extends StatefulWidget {
  const GreenFootprintScreen({super.key});

  @override
  State<GreenFootprintScreen> createState() => _GreenFootprintScreenState();
}

class _GreenFootprintScreenState extends State<GreenFootprintScreen> {
  GreenFootprint? _data;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _hasError = false;
    });
    try {
      final service = Provider.of<UserService>(context, listen: false);
      final data = await service.getGreenFootprint();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.greenFootprint,
        automaticallyImplyLeading: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHero(_data!),
                        const _Divider(),
                        _buildPlantContributions(_data!),
                        const _Divider(),
                        _buildWeeklyChart(_data!),
                        const _Divider(),
                        // Equivalencias calculadas desde el CO2 real.
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 4),
                          child: ImpactEquivalentsCard(
                            totalGrams: _data!.totalKg * 1000,
                          ),
                        ),
                        _buildShareCTA(_data!),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 44, color: _kTextMuted),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.footprintError,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'DM Sans', color: _kTextMuted),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
                onPressed: _load,
                child: Text(AppLocalizations.of(context)!.retry)),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(GreenFootprint data) {
    // Un ejemplar de interior fija décimas de gramo al día, así que dos
    // decimales; con uno solo casi todo se vería como "0.0".
    final value = data.gramsPerDay.toStringAsFixed(2);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.co2AbsorbedToday,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: _kTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w900,
              fontSize: 72,
              color: _kDark,
              height: 1.0,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.gramsPerDay,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: _kTextMuted,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA3AB78).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data.plantCount == 0
                  ? AppLocalizations.of(context)!.noPlantsYet
                  : AppLocalizations.of(context)!.accumulatedGrams(
                      (data.totalKg * 1000).toStringAsFixed(2)),
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: _kTextDark,
              ),
            ),
          ),
          if (data.hasDerivedValues) ...[
            const SizedBox(height: 10),
            // De las 51 especies del catálogo solo 9 tienen medición publicada.
            // Decirlo evita presentar una inferencia como si fuera un dato.
            Text(
              AppLocalizations.of(context)!.estimatedValueNote(data.measured, data.plantCount),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 11,
                color: _kTextMuted,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlantContributions(GreenFootprint data) {
    if (data.breakdown.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        child: Text(
          AppLocalizations.of(context)!.addPlantsToSeeContribution,
          style: const TextStyle(fontFamily: 'DM Sans', fontSize: 13, color: _kTextMuted),
        ),
      );
    }

    // La barra se escala contra el mayor valor absoluto, para que una planta
    // con aporte negativo también se represente proporcionalmente.
    final maxAbs = data.breakdown
        .map((p) => p.gramsPerDay.abs())
        .fold<double>(0, (a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.contributionPerPlant,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 12),
          ...data.breakdown.map((p) {
            final ratio = maxAbs == 0 ? 0.0 : (p.gramsPerDay.abs() / maxAbs).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: _kTextDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Stack(
                        children: [
                          Container(height: 10, color: _kBarBg),
                          FractionallySizedBox(
                            widthFactor: ratio,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: _kDark,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 52,
                    child: Text(
                      // El valor se muestra tal cual, negativo incluido.
                      '${p.gramsPerDay.toStringAsFixed(2)} g',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: _kTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(GreenFootprint data) {
    const chartHeight = 110.0;
    final days = data.last7Days;
    if (days.isEmpty) return const SizedBox.shrink();

    // Escala por valor absoluto para que los días negativos también se vean.
    final maxAbs = days
        .map((d) => d.gramsPerDay.abs())
        .fold<double>(0, (a, b) => a > b ? a : b);

    const labels = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.weeklyEvolution,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.weeklyEvolutionHelp,
            style: const TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: _kTextMuted),
          ),
          const SizedBox(height: 12),
          Container(
            height: chartHeight + 40,
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(days.length, (i) {
                final d = days[i];
                final barH = maxAbs == 0 ? 0.0 : (d.gramsPerDay.abs() / maxAbs) * chartHeight;
                // Etiqueta a partir de la fecha real devuelta por el backend.
                final parsed = DateTime.tryParse(d.date);
                final label = parsed == null ? '' : labels[parsed.weekday % 7];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: barH < 2 && d.gramsPerDay != 0 ? 2 : barH,
                      decoration: BoxDecoration(
                        color: _kDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: _kTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareCTA(GreenFootprint data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _kLime,
            foregroundColor: _kTextDark,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
          ),
          icon: const Icon(Icons.copy_rounded, size: 20),
          label: Text(AppLocalizations.of(context)!.copyMyFootprint,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          // El botón antes tenía `onPressed: () {}` y no hacía nada. Copiar al
          // portapapeles funciona sin añadir dependencias; si se quiere abrir
          // el diálogo de compartir del sistema hace falta un paquete como
          // share_plus.
          onPressed: () async {
            final resumen = data.plantCount == 0
                ? AppLocalizations.of(context)!.footprintShareEmpty
                : AppLocalizations.of(context)!.footprintShareSummary(
                    data.plantCount,
                    data.gramsPerDay.toStringAsFixed(2),
                    (data.totalKg * 1000).toStringAsFixed(2),
                  );
            await Clipboard.setData(ClipboardData(text: resumen));
            if (!mounted) return;
            showAppToast(context, AppLocalizations.of(context)!.copiedToClipboard, type: ToastType.success);
          },
        ),
      ),
    );
  }
}

// ── Thin divider line ─────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFFE0E1DD),
    );
  }
}
