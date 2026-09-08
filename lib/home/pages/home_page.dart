import 'package:flutter/material.dart';
import 'package:skynova/home/models/tendays_model.dart';
import 'package:skynova/home/pages/tendays_page.dart';
import 'package:skynova/home/pages/today_page.dart';
import 'package:skynova/home/pages/tomorrow_page.dart';
import 'package:skynova/home/widgets/homepage_widget.dart';

class HomePage extends StatefulWidget {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final int sunrise;
  final int sunset;
  final String icon;
  final List<dynamic> hourlyList;
  final List<TendaysModel> daily;

  final Function(String) onCityChanged;

  const HomePage({
    super.key,
    required this.location,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.weather,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.sunrise,
    required this.sunset,
    required this.icon,
    required this.onCityChanged,
    required this.hourlyList,
    required this.daily,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool isFahrenheit = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [

            // Header
            SliverPersistentHeader(
              pinned: true,
              delegate: WeatherImageHeaderDelegate(
                location: widget.location,
                temp: widget.temp,
                weather: widget.weather,
                tempMin: widget.tempMin,
                tempMax: widget.tempMax,
                feelsLike: widget.feelsLike,
                sunrise: widget.sunrise,
                sunset: widget.sunset,
                selectedIndex: selectedIndex,
                onTabChange: (i) {
                  setState(() => selectedIndex = i);
                },
                tabController: _tabController,
                onCityChanged: widget.onCityChanged,
                icon: widget.icon,
                hourlyList: widget.hourlyList,
                isFahrenheit: isFahrenheit,
                onUnitToggle: () {
                  setState(() => isFahrenheit = !isFahrenheit);
                },
                daily: widget.daily,
              ),
            ),
          ];
        },

        body: TabBarView(
          controller: _tabController,
          children: [
            TodayPage(
              windSpeed: widget.windSpeed,
              humidity: widget.humidity,
              temp: widget.temp,
              weather: widget.weather,
              hourlyList: widget.hourlyList,
              sunrise: widget.sunrise,
              sunset: widget.sunset,
              isFahrenheit: isFahrenheit,
            ),
            TomorrowPage(
              daily: widget.daily,
              windSpeed: widget.windSpeed,
              humidity: widget.humidity,
              temp: widget.temp,
            ),
            TendayPage(daily: widget.daily),
          ],
        ),
      ),
    );
  }
}
