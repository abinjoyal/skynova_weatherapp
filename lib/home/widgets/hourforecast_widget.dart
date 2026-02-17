import 'package:flutter/material.dart';
import 'package:flutter_application_5/home/theme/colors.dart';
import 'package:flutter_application_5/home/theme/styles.dart';

class HourForecastCard extends StatelessWidget {
  final List<dynamic> hourlyList;

  const HourForecastCard({super.key, required this.hourlyList});

  @override
  Widget build(BuildContext context) {
    debugPrint("Hourly received: ${hourlyList.length}");

    final count = hourlyList.length < 8 ? hourlyList.length : 8;
final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.19,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.chipSelected.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
      child: hourlyList.isEmpty
          ? const Center(child: Text("No hourly data"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    SizedBox(width: size.width*0.01),
                    const Text(
                      "Hourly forecast",
                      style: AppTextStyles.cardValue,
                    ),
                  ],
                ),
                SizedBox(height: size.height*0.03),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(count, (i) {
                      final h = hourlyList[i] as Map<String, dynamic>;

                      final dt = h['dt'] ?? 0;
                      final time = TimeOfDay.fromDateTime(
                        DateTime.fromMillisecondsSinceEpoch(dt * 1000),
                      ).format(context);

                      final icon = h['weather'][0]['icon'];
                      final tempValue = (h['main']?['temp'] ?? h['temp'] ?? 0)
                          .toDouble();
                      final temp = "${tempValue.toStringAsFixed(0)}°";

                      return Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: Column(
                          children: [
                            Text(time, style: AppTextStyles.smallcardTitle),
                            const SizedBox(height: 8),
                            Image.network(
                              "https://openweathermap.org/img/wn/$icon@2x.png",
                              width: size.width*0.11,
                              height: size.height*0.04,
                            ),
                            SizedBox(height: size.height*0.00),
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
              ],
            ),
    );
  }
}
