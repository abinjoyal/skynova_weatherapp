import 'package:flutter/material.dart';
import 'package:flutter_application_5/home/theme/colors.dart';
import 'package:flutter_application_5/home/theme/styles.dart';

class SunCardsSection extends StatelessWidget {
  final int sunrise;
  final int sunset;
  final String Function(int) formatTime;
  final String Function(int) timeAgo;

  const SunCardsSection({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.formatTime,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        _sunCard(
          context,
          "Sunrise",
          formatTime(sunrise),
          timeAgo(sunrise),
          Icons.sunny,
        ),
        SizedBox(width: size.width * 0.02),
        _sunCard(
          context,
          "Sunset",
          formatTime(sunset),
          timeAgo(sunset),
          Icons.wb_sunny_outlined,
        ),
      ],
    );
  }
}

Widget _sunCard(
  BuildContext context,
  String title,
  String time,
  String sub,
  IconData icon,
) {
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
          SizedBox(width: size.width * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              Row(
                children: [
                  Text(time),
                  SizedBox(width: size.width * 0.08),
                  Text(
                    sub,
                     style: AppTextStyles.ValueTittle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
