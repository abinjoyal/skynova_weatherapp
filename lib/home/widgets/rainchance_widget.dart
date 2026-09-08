import 'package:flutter/material.dart';
import 'package:skynova/home/theme/colors.dart';
import 'package:skynova/home/theme/styles.dart';

class RainChanceCard extends StatelessWidget {
  final List<dynamic> hourlyList;

  const RainChanceCard({super.key, required this.hourlyList});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (hourlyList.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget bar(String time, double value) {
      final percentInt = (value * 100).round();
      String intensityTag = "Low";
      if (percentInt > 70) {
        intensityTag = "Heavy Rain";
      } else if (percentInt > 40) {
        intensityTag = "Rain Likely";
      } else if (percentInt > 15) {
        intensityTag = "Light Drizzle";
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                time,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.blueAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  widthFactor: value.clamp(0.05, 1.0),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blueAccent, Colors.indigo],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$percentInt%",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    intensityTag,
                    style: TextStyle(
                      fontSize: 10,
                      color: percentInt > 50 ? Colors.indigo : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final count = hourlyList.length < 4 ? hourlyList.length : 4;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, size: 18, color: Colors.blueAccent),
              SizedBox(width: size.width * 0.02),
              const Text(
                "Precipitation & Rain Chance",
                style: AppTextStyles.cardValue,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Column(
            children: List.generate(count, (i) {
              final h = hourlyList[i];
              final pop = (h['pop'] ?? 0).toDouble();

              final dt = DateTime.fromMillisecondsSinceEpoch(
                (h['dt'] ?? 0) * 1000,
              );

              final time = TimeOfDay.fromDateTime(dt).format(context);

              return bar(time, pop);
            }),
          ),
        ],
      ),
    );
  }
}

class UVIndexCard extends StatelessWidget {
  final double temp;

  const UVIndexCard({super.key, required this.temp});

  int get estimatedUV {
    final hour = DateTime.now().hour;
    if (hour < 6 || hour > 18) return 0; // Night time
    if (temp > 35) return 9;
    if (temp > 30) return 7;
    if (temp > 25) return 5;
    if (temp > 18) return 3;
    return 2;
  }

  Color get uVColor {
    final uv = estimatedUV;
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.amber.shade700;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.redAccent;
    return Colors.purple;
  }

  String get uVTitle {
    final uv = estimatedUV;
    if (uv <= 2) return "Low";
    if (uv <= 5) return "Moderate";
    if (uv <= 7) return "High";
    if (uv <= 10) return "Very High";
    return "Extreme";
  }

  String get uVAdvice {
    final uv = estimatedUV;
    if (uv <= 2) return "Minimal sun protection needed.";
    if (uv <= 5) return "Wear sunglasses & SPF 30+ sunscreen.";
    if (uv <= 7) return "Seek shade during peak midday hours.";
    if (uv <= 10) return "Avoid outdoor sun exposure around noon.";
    return "Extreme risk! Stay indoors when possible.";
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final uv = estimatedUV;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 18, color: Colors.orange.shade700),
              SizedBox(width: size.width * 0.02),
              const Text(
                "UV Index Risk Level",
                style: AppTextStyles.cardValue,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: uVColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$uv - $uVTitle",
                  style: TextStyle(
                    color: uVColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.015),

          // UV Gauge Progress Bar (0 to 11+)
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                  Colors.purple,
                ],
              ),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: (uv / 11).clamp(0.05, 1.0),
                  alignment: Alignment.centerLeft,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.012),

          Text(
            uVAdvice,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
