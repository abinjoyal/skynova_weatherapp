import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:skynova/home/theme/colors.dart';
import 'package:skynova/home/theme/styles.dart';

class DayForecastSection extends StatelessWidget {
  final List<double> temps;
  final List<String> days;

  const DayForecastSection({
    super.key,
    required this.temps,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    if (temps.isEmpty) {
      return const SizedBox.shrink();
    }
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18),
              SizedBox(width: size.height*0.01),
              const Text(
                "Day forecast",
                style: AppTextStyles.cardValue,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
            height: size.height*0.20,
            child: DayForecastGraph(weeklyTemps: temps, weekDays: days),
          ),
        ],
      ),
    );
  }
}

class DayForecastGraph extends StatelessWidget {
  final List<double> weeklyTemps;
  final List<String> weekDays;

  const DayForecastGraph({
    super.key,
    required this.weeklyTemps,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    final minY = weeklyTemps.reduce((a, b) => a < b ? a : b);
    final maxY = weeklyTemps.reduce((a, b) => a > b ? a : b);

    return LineChart(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      LineChartData(
        minX: 0,
        maxX: weeklyTemps.length - 1,
        minY: minY - 1,
        maxY: maxY + 1,
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= weekDays.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  weekDays[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),

        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              weeklyTemps.length,
              (i) => FlSpot(i.toDouble(), weeklyTemps[i]),
            ),
            isCurved: true,
            barWidth: 4,
            color:  AppColors.cardBackground,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [  AppColors.cardBackground, Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
