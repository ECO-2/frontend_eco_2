import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';

const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);
const _kGood = Color(0xFF6FCF97);
const _kModerate = Color(0xFFF2C94C);
const _kBad = Color(0xFFEB5757);

class Co2QualityScreen extends StatefulWidget {
  const Co2QualityScreen({super.key});

  @override
  State<Co2QualityScreen> createState() => _Co2QualityScreenState();
}

class _Co2QualityScreenState extends State<Co2QualityScreen> {
  Co2Summary? _data;
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
      final data = await service.getCo2Summary();
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

  Color _colorForPpm(int ppm) {
    if (ppm < 1000) return _kGood;
    if (ppm < 2000) return _kModerate;
    return _kBad;
  }

  String _labelForPpm(int ppm) {
    final l10n = AppLocalizations.of(context)!;
    if (ppm < 1000) return l10n.airQualityGood;
    if (ppm < 2000) return l10n.airQualityModerate;
    return l10n.airQualityPoor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.airQuality,
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
                        _buildWeeklyChart(_data!),
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
              AppLocalizations.of(context)!.co2SummaryError,
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

  Widget _buildHero(Co2Summary data) {
    final hasReading = data.currentPpm != null;
    final ppm = data.currentPpm ?? 0;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.currentCo2Level,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: _kTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasReading ? ppm.toString() : '—',
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w900,
              fontSize: 72,
              color: _kDark,
              height: 1.0,
            ),
          ),
          const Text(
            'ppm',
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
              color: hasReading
                  ? _colorForPpm(ppm).withValues(alpha: 0.2)
                  : const Color(0xFFA3AB78).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              hasReading
                  ? _labelForPpm(ppm)
                  : AppLocalizations.of(context)!.noReadingsYet,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: _kTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(Co2Summary data) {
    const chartHeight = 110.0;
    final days = data.last7Days;
    if (days.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        child: Text(
          AppLocalizations.of(context)!.noReadingsYet,
          style: const TextStyle(fontFamily: 'DM Sans', fontSize: 13, color: _kTextMuted),
        ),
      );
    }

    final maxPpm = days.map((d) => d.avgPpm).fold<int>(0, (a, b) => a > b ? a : b);
    const labels = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.weeklyEvolution,
            style: const TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _kTextDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.co2WeeklyEvolutionHelp,
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
                final barH = maxPpm == 0 ? 0.0 : (d.avgPpm / maxPpm) * chartHeight;
                final parsed = DateTime.tryParse(d.date);
                final label = parsed == null ? '' : labels[parsed.weekday % 7];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: barH < 2 && d.avgPpm != 0 ? 2 : barH,
                      decoration: BoxDecoration(
                        color: _colorForPpm(d.avgPpm),
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
}

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