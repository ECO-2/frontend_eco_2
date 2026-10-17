import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';

class MetricBarChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final String unit;
  final Color barColor;
  final Color touchedColor;

  const MetricBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.unit,
    this.barColor = AppColors.primary,
    this.touchedColor = AppColors.accent,
  });

  @override
  State<MetricBarChart> createState() => _MetricBarChartState();
}

class _MetricBarChartState extends State<MetricBarChart> {
  int _touchedBarIndex = -1;

  double get _maxValue =>
      widget.values.isEmpty ? 0 : widget.values.reduce((a, b) => a > b ? a : b);

  double get _gridInterval {
    final max = _maxValue;
    if (max <= 10) return 2;
    if (max <= 100) return 20;
    if (max <= 1000) return 200;
    return (max / 5).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundBarHeight = _maxValue == 0 ? 8.0 : _maxValue * 1.2;

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECE9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  _touchedBarIndex = -1;
                  return;
                }
                _touchedBarIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.primaryDark,
              tooltipBorderRadius: BorderRadius.circular(8),
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tooltipMargin: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(1)} ${widget.unit}',
                  const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final int index = value.toInt();
                  if (index >= 0 && index < widget.labels.length) {
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        widget.labels[index],
                        style: TextStyle(
                          color: _touchedBarIndex == index
                              ? AppColors.primaryDark
                              : AppColors.textSecondary,
                          fontWeight: _touchedBarIndex == index ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    meta: meta,
                    space: 4,
                    child: Text(
                      value.round().toString(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _gridInterval,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xFFF1F4F2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(widget.values.length, (i) {
            final isTouched = i == _touchedBarIndex;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: widget.values[i],
                  color: isTouched ? widget.touchedColor : widget.barColor,
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: backgroundBarHeight,
                    color: const Color(0xFFF1F3F2),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}