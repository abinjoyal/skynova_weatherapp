import 'package:flutter/material.dart';
import 'package:flutter_application_5/home/theme/colors.dart';
import 'package:flutter_application_5/home/theme/styles.dart';

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
      return Row(
        children: [
          SizedBox(width: size.width*0.1, child: Text(time)),
          Expanded(
            child: Container(
              height: size.height * 0.03,
              decoration: BoxDecoration(
                color:AppColors.primaryStart.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: FractionallySizedBox(
                widthFactor: value,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color:AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.02),
          Text("${(value * 100).round()}%"),
        ],
      );
    }

    final count = hourlyList.length < 4 ? hourlyList.length : 4;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
              color:  AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, size: 18),
              SizedBox(width: size.width * 0.01),
              const Text(
                "Chance of rain",
                style: AppTextStyles.cardValue,)
            ],
          ),
          SizedBox(height: size.height*0.02),

          Column(
            children: List.generate(count, (i) {
              final h = hourlyList[i];
              final pop = (h['pop'] ?? 0).toDouble();

              final dt = DateTime.fromMillisecondsSinceEpoch(
                (h['dt'] ?? 0) * 1000,
              );

              final time = TimeOfDay.fromDateTime(dt).format(context);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: bar(time, pop),
              );
            }),
          ),
        ],
      ),
    );
  }
}
