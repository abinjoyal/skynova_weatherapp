import 'package:flutter/material.dart';
import 'package:skynova/home/theme/colors.dart';
import 'package:skynova/home/theme/styles.dart';

class InfoCardsSection extends StatelessWidget {
  final double windSpeed;
  final int humidity;
  final double temp;
  final String weather;
  final bool isFahrenheit;

  const InfoCardsSection({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.temp,
    required this.weather,
    this.isFahrenheit = false,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final displayTempStr = isFahrenheit
        ? "${((temp * 9 / 5) + 32).toStringAsFixed(1)}°F"
        : "${temp.toStringAsFixed(1)}°C";

    return Column(
      children: [
        Row(
          children: [
            _infoCard(
              context,
              icon: Icons.air,
              title: "Wind speed",
              value: "${windSpeed.toStringAsFixed(1)} km/h",
            ),
            SizedBox(width: size.width * 0.02),
            _infoCard(
              context,
              icon: Icons.water_drop,
              title: "Humidity",
              value: "$humidity%",
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          children: [
            _infoCard(
              context,
              icon: Icons.thermostat,
              title: "Temperature",
              value: displayTempStr,
            ),
            SizedBox(width: size.width * 0.02),
            _infoCard(
              context,
              icon: Icons.cloud,
              title: "Weather",
              value: weather,
            ),
          ],
        ),
      ],
    );
  }
}

Widget _infoCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
}) {
  final Size size = MediaQuery.of(context).size;
  return Expanded(
    child: Container(
      height: size.height * 0.08,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: size.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              SizedBox(height: size.height * 0.00),
              Text(value,  style: AppTextStyles.ValueTittle,),
            ],
          ),
        ],
      ),
    ),
  );
}
