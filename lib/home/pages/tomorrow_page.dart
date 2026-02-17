import 'package:flutter/material.dart';
import 'package:flutter_application_5/home/theme/colors.dart';
import 'package:flutter_application_5/home/theme/styles.dart';
import '../models/tendays_model.dart';

class TomorrowPage extends StatelessWidget {
  final List<TendaysModel> daily;
  final double windSpeed;
  final int humidity;
  final double temp;

  const TomorrowPage({
    super.key,
    required this.daily,
    required this.windSpeed,
    required this.humidity,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    if (daily.length < 2) {
      return const Center(child: Text("No tomorrow data"));
    }

    final tomorrow = daily[1];
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tomorrow - ${tomorrow.dayName}",
                        style: AppTextStyles.cardValue,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(tomorrow.condition),
                      SizedBox(height: size.height * 0.01),

                      Row(
                        children: [
                          _miniInfo(
                            context,
                            Icons.air,
                            "${windSpeed.toStringAsFixed(0)} km/h",
                          ),
                          SizedBox(width: size.height*0.01),
                          _miniInfo(
                            context,
                            Icons.water_drop,
                            "$humidity%"),
                          SizedBox(width: size.height*0.01),
                          _miniInfo(
                            context,
                            Icons.thermostat,
                            "${temp.toStringAsFixed(1)}°C",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.network(tomorrow.icon, width: 63),
                      const SizedBox(height: 2),
                      Text(
                        "${tomorrow.maxTemp.round()}° / ${tomorrow.minTemp.round()}°",
                        style: AppTextStyles.cardValueTittle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfo(BuildContext context,IconData icon, String text) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.darkText,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: size.width*0.01),
        Text(
          text,
          style: AppTextStyles.smallcardTitle,
        ),
      ],
    );
  }
}
