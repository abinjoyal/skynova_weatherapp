// ignore: unnecessary_import
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_5/home/pages/search_page.dart';
import 'package:flutter_application_5/home/theme/colors.dart';
import 'package:flutter_application_5/home/theme/styles.dart';
import 'package:intl/intl.dart';

class WeatherImageHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String location;
  final double temp;
  final String weather;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int sunrise;
  final int sunset;
  final String icon;
  final int selectedIndex;
  final TabController tabController;
  final ValueChanged<int> onTabChange;
  final Function(String) onCityChanged;
  final List<dynamic> hourlyList;

  WeatherImageHeaderDelegate({
    required this.selectedIndex,
    required this.tabController,
    required this.onTabChange,
    required this.location,
    required this.temp,
    required this.weather,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
    required this.onCityChanged,
    required this.icon,
    required this.hourlyList,
    required daily,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final formattedDate = DateFormat("MMMM d, HH:mm").format(DateTime.now());

    final percent = (1 - (shrinkOffset / (maxExtent - minExtent))).clamp(
      0.0,
      1.0,
    );

    final fontSize = 70 * percent + 24;
    final imageSize = 60 * percent + 40;
    final feelsSize = 4 * percent + 10;
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 14, 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryStart, AppColors.primaryEnd],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      //
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.04),

          /// LOCATION + SEARCH
          Row(
            children: [
              Text(location, style: AppTextStyles.city),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  final city = await showSearch(
                    context: context,
                    delegate: CitySearchDelegate(),
                  );

                  if (city != null && city.isNotEmpty) {
                    onCityChanged(city);
                  }
                },
              ),
            ],
          ),

          /// TEMP + ICON
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${temp.toStringAsFixed(0)}°",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteText,
                ),
              ),
              SizedBox(width: size.width * 0.00),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(
                  "Feels like ${feelsLike.toStringAsFixed(0)}°",
                  style: TextStyle(
                    color: AppColors.whiteText,
                    fontSize: feelsSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Image.network(
                    "https://openweathermap.org/img/wn/$icon@2x.png",
                    width: imageSize,
                    height: imageSize,
                  ),
                  Text(
                    weather,
                    style: const TextStyle(
                      color: AppColors.whiteText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),
          Text(
            formattedDate,
            style: const TextStyle(
              color: AppColors.whiteText,
              fontWeight: FontWeight.bold,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 10 * percent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tab("Today", 0),
                _tab("Tomorrow", 1),
                _tab("07 days", 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 225;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  Widget _tab(String text, int index) {
    return GestureDetector(
      onTap: () {
        onTabChange(index);
        tabController.animateTo(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
        decoration: BoxDecoration(
          color: selectedIndex == index
              ? AppColors.whiteText
              // ignore: deprecated_member_use
              : AppColors.whiteOpacity,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedIndex == index
                ? AppColors.darkText
                : AppColors.whiteText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
