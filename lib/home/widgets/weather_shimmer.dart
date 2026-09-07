import 'package:flutter/material.dart';
import 'package:skynova/home/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class WeatherShimmer extends StatelessWidget {
  const WeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.all(12),
          height: size.height * 0.08,
          decoration: BoxDecoration(
            color: AppColors.whiteText,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
