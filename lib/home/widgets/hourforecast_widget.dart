import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:skynova/home/theme/colors.dart';
import 'package:skynova/home/theme/styles.dart';

class HourForecastCard extends StatefulWidget {
  final List<dynamic> hourlyList;
  final bool isFahrenheit;

  const HourForecastCard({
    super.key,
    required this.hourlyList,
    this.isFahrenheit = false,
  });

  @override
  State<HourForecastCard> createState() => _HourForecastCardState();
}

class _HourForecastCardState extends State<HourForecastCard> {
  bool isGraphView = true;

  @override
  Widget build(BuildContext context) {
    if (widget.hourlyList.isEmpty) {
      return Container(
        height: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: AppColors.chipSelected.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text("No hourly data")),
      );
    }

    final count = widget.hourlyList.length < 8 ? widget.hourlyList.length : 8;
    final displayList = widget.hourlyList.take(count).toList();
    final Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: AppColors.chipSelected.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, size: 18),
              SizedBox(width: size.width * 0.01),
              const Text(
                "Hourly forecast",
                style: AppTextStyles.cardValue,
              ),
              const Spacer(),
              InkWell(
                onTap: () => setState(() => isGraphView = !isGraphView),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isGraphView ? Icons.view_list : Icons.show_chart,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isGraphView ? "Cards" : "Graph",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isGraphView
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: SizedBox(
              height: 130,
              child: _HourlyGraph(
                hourlyList: displayList,
                isFahrenheit: widget.isFahrenheit,
              ),
            ),
            secondChild: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(count, (i) {
                  final h = displayList[i] as Map<String, dynamic>;

                  final dt = h['dt'] ?? 0;
                  final time = TimeOfDay.fromDateTime(
                    DateTime.fromMillisecondsSinceEpoch(dt * 1000),
                  ).format(context);

                  final icon = h['weather'][0]['icon'];
                  final rawTemp = (h['main']?['temp'] ?? h['temp'] ?? 0).toDouble();
                  final tempValue = widget.isFahrenheit ? (rawTemp * 9 / 5) + 32 : rawTemp;
                  final temp = "${tempValue.toStringAsFixed(0)}°";

                  return Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Column(
                      children: [
                        Text(time, style: AppTextStyles.smallcardTitle),
                        const SizedBox(height: 4),
                        Image.network(
                          "https://openweathermap.org/img/wn/$icon@2x.png",
                          width: 36,
                          height: 36,
                        ),
                        Text(
                          temp,
                          style: AppTextStyles.ValueTittle,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyGraph extends StatelessWidget {
  final List<dynamic> hourlyList;
  final bool isFahrenheit;

  const _HourlyGraph({
    required this.hourlyList,
    required this.isFahrenheit,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> temps = [];
    final List<String> times = [];

    for (var item in hourlyList) {
      final h = item as Map<String, dynamic>;
      final rawTemp = (h['main']?['temp'] ?? h['temp'] ?? 0).toDouble();
      final tempValue = isFahrenheit ? (rawTemp * 9 / 5) + 32 : rawTemp;
      temps.add(tempValue);

      final dt = h['dt'] ?? 0;
      final time = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(dt * 1000),
      ).format(context);
      times.add(time);
    }

    if (temps.isEmpty) return const SizedBox.shrink();

    final minY = temps.reduce((a, b) => a < b ? a : b) - 2;
    final maxY = temps.reduce((a, b) => a > b ? a : b) + 3;
    final unitSuffix = isFahrenheit ? "°F" : "°C";

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (temps.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final idx = spot.x.toInt();
                final tempStr = "${spot.y.toStringAsFixed(0)}$unitSuffix";
                final timeStr = idx < times.length ? times[idx] : "";
                return LineTooltipItem(
                  "$timeStr\n$tempStr",
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= times.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    times[idx],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              temps.length,
              (i) => FlSpot(i.toDouble(), temps[i]),
            ),
            isCurved: true,
            barWidth: 3,
            color: Colors.indigoAccent,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: Colors.indigo,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // ignore: deprecated_member_use
                  Colors.indigoAccent.withOpacity(0.35),
                  // ignore: deprecated_member_use
                  Colors.indigoAccent.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
