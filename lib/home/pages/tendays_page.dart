import 'package:flutter/material.dart';
import 'package:flutter_application_5/home/models/tendays_model.dart';
import 'package:flutter_application_5/home/theme/colors.dart';
import 'package:flutter_application_5/home/theme/styles.dart';

class TendayPage extends StatelessWidget {
  final List<TendaysModel> daily;

  const TendayPage({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    if (daily.isEmpty) {
      return const Center(child: Text("No forecast data"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: daily.length,
      itemBuilder: (context, index) {
        final day = daily[index];

        String displayDay;
        if (index == 0) {
          displayDay = "Today";
        } else if (index == 1) {
          displayDay = "Tomorrow";
        } else {
          displayDay = day.dayName;
        }
        final Size size = MediaQuery.of(context).size;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.chipSelected.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                /// Day + date
                SizedBox(
                  width: size.width * 0.28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayDay,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        day.dateLabel,
                        style: AppTextStyles.smallTemp,
                      ),
                    ],
                  ),
                ),

                /// Weather icon
                Image.network(
                  day.icon,
                  width: size.width * 0.10,
                  height: size.height * 0.05,
                ),

                SizedBox(width: size.width * 0.1),

                /// Min temperature
                SizedBox(
                  width: size.width * 0.08,
                  child: Text(
                    "${day.minTemp.toStringAsFixed(0)}°",
                    textAlign: TextAlign.right,
                  ),
                ),

                SizedBox(width: size.width * 0.02),

                /// Temperature range bar
                Expanded(
                  child: Container(
                    height: size.height * 0.01,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.rangebar,
                          AppColors.rangebor,
                          AppColors.rangebor,
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: size.width * 0.02),

                /// Max temperature
                SizedBox(
                  height: size.height * 0.02,
                  child: Text(
                    "${day.maxTemp.toStringAsFixed(0)}°",
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
