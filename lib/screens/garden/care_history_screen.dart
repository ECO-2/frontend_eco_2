import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/models/models.dart';
import 'package:frontend_eco_2/services/services.dart';
import 'package:frontend_eco_2/utils/care_task_labels.dart';
import 'package:frontend_eco_2/widgets/common/custom_app_bar.dart';
import 'package:frontend_eco_2/widgets/common/app_toast.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/utils/date_labels.dart';

// Claves estables, no etiquetas: el estado guardaba el texto visible, asi que
// el filtro dejaba de coincidir en cuanto la app cambiaba de idioma.
const _kFilters = ['all', 'watering', 'pruning', 'fertilizing'];

String _filterLabel(BuildContext context, String key) {
  final l = AppLocalizations.of(context)!;
  switch (key) {
    case 'watering':
      return l.waterings;
    case 'pruning':
      return l.prunings;
    case 'fertilizing':
      return l.fertilizings;
    default:
      return l.filterAll;
  }
}

class CareHistoryScreen extends StatefulWidget {
  const CareHistoryScreen({super.key});

  @override
  State<CareHistoryScreen> createState() => _CareHistoryScreenState();
}

class _CareHistoryScreenState extends State<CareHistoryScreen> {
  String _selectedFilter = 'all';
  UserPlant? _plant;
  List<CareLog>? _logs;
  bool _hasError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_plant == null) {
      _plant = ModalRoute.of(context)?.settings.arguments as UserPlant?;
      _loadLogs();
    }
  }

  Future<void> _loadLogs() async {
    final plant = _plant;
    if (plant == null) return;
    try {
      final logs = await Provider.of<CareService>(context, listen: false).getCareLogs(plant.id);
      if (!mounted) return;
      setState(() => _logs = logs);
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nickname = _plant?.nickname ?? AppLocalizations.of(context)!.thisPlant;
    final logs = _logs ?? const <CareLog>[];

    final riegos = logs.where((l) => l.taskType == 'watering').length;
    final fertilizaciones = logs.where((l) => l.taskType == 'fertilizing').length;
    final podas = logs.where((l) => l.taskType == 'pruning').length;

    final filteredLogs = logs.where((l) {
      if (_selectedFilter == 'all') return true;
      return l.taskType == _selectedFilter;
    }).toList()
      ..sort((a, b) => b.performedAt.compareTo(a.performedAt));

    final grouped = <String, List<CareLog>>{};
    for (final log in filteredLogs) {
      // Antes venia de una lista de meses en espanol escrita a mano.
      final key = formatMonthYear(context, log.performedAt);
      grouped.putIfAbsent(key, () => []).add(log);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        automaticallyImplyLeading: true,
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.history,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              nickname,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 12,
                color: Color(0xFFBEE664),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => _showComingSoon(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.download_rounded, size: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _logs == null && !_hasError
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_hasError)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(AppLocalizations.of(context)!.historyLoadFailed,
                                style: const TextStyle(color: Colors.red)),
                          ),
                        // Upper counts card — totales reales del historial completo.
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildMetricCol(
                                  icon: Icons.water_drop_rounded,
                                  iconColor: const Color(0xFF4A90D9),
                                  iconBgColor: const Color(0xFFEAF3FC),
                                  value: '$riegos',
                                  label: AppLocalizations.of(context)!.waterings,
                                ),
                              ),
                              Container(width: 1, height: 40, color: const Color(0xFFE2E7E4)),
                              Expanded(
                                child: _buildMetricCol(
                                  icon: Icons.grain_rounded,
                                  iconColor: const Color(0xFF8A9A65),
                                  iconBgColor: const Color(0xFFEFF5E4),
                                  value: '$fertilizaciones',
                                  label: AppLocalizations.of(context)!.careTypeFertilizing,
                                ),
                              ),
                              Container(width: 1, height: 40, color: const Color(0xFFE2E7E4)),
                              Expanded(
                                child: _buildMetricCol(
                                  icon: Icons.content_cut_rounded,
                                  iconColor: const Color(0xFFF56B1C),
                                  iconBgColor: const Color(0xFFFFF0EC),
                                  value: '$podas',
                                  label: AppLocalizations.of(context)!.prunings,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Filter Row
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final f in _kFilters) ...[
                                      if (f != _kFilters.first)
                                        const SizedBox(width: 8),
                                      _buildFilterChip(f),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        if (grouped.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                logs.isEmpty
                                    ? AppLocalizations.of(context)!.noCareLoggedForPlant
                                    : AppLocalizations.of(context)!.noEventsForFilter,
                                style: const TextStyle(color: Color(0xFF807F7F)),
                              ),
                            ),
                          )
                        else
                          for (final entry in grouped.entries) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF0D2B31),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.eventsCount(entry.value.length),
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF807F7F)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: entry.value.length,
                              itemBuilder: (context, index) {
                                final log = entry.value[index];
                                final visual = careTaskVisual(log.taskType);
                                final isFirst = index == 0;
                                final isLast = index == entry.value.length - 1;

                                return IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              top: isFirst ? 28 : 0,
                                              bottom: isLast ? 28 : 0,
                                              left: 19,
                                              child: Container(width: 2, color: const Color(0xFFE2E7E4)),
                                            ),
                                            Positioned(
                                              top: 20,
                                              child: Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: visual.color, width: 3.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 12.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 36,
                                                  height: 36,
                                                  decoration:
                                                      BoxDecoration(color: visual.background, shape: BoxShape.circle),
                                                  alignment: Alignment.center,
                                                  child: Icon(visual.icon, color: visual.color, size: 18),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            careTaskLabel(
                                                                context, log.taskType),
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                              color: Color(0xFF0D2B31),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            formatDayMonth(context, log.performedAt),
                                                            style: const TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xFF807F7F),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D2B31),
                      side: const BorderSide(color: Color(0xFF0D2B31), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => _showComingSoon(context),
                    icon: const Icon(Icons.calendar_today_rounded, size: 16),
                    label: Text(AppLocalizations.of(context)!.exportToCalendar,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showAppToast(context, AppLocalizations.of(context)!.featureComingSoon);
  }

  Widget _buildMetricCol({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0D2B31)),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF807F7F))),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String key) {
    final isSelected = _selectedFilter == key;
    final label = _filterLabel(context, key);

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D2B31) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: const Color(0xFFE2E7E4), width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xFF5A6F6C),
          ),
        ),
      ),
    );
  }
}
