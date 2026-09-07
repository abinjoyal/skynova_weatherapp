import 'package:flutter/material.dart';
import 'package:skynova/home/widgets/dailyforecast_widget.dart';
import 'package:skynova/home/widgets/hourforecast_widget.dart';
import 'package:skynova/home/widgets/rainchance_widget.dart';
import 'package:skynova/home/widgets/infocard_widget.dart';
import 'package:skynova/home/widgets/suncard_widget.dart';

class TodayPage extends StatelessWidget {
  final double windSpeed;
  final int humidity;
  final double temp;
  final String weather;
  final List<dynamic> hourlyList;

  final int sunrise;
  final int sunset;

  const TodayPage({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.temp,
    required this.weather,
    required this.hourlyList,
    required this.sunrise,
    required this.sunset,
  });

  List<double> extractDailyTemps(List<dynamic> hourlyList) {
    if (hourlyList.isEmpty) return [];

    final Map<String, List<double>> grouped = {};

    for (var h in hourlyList) {
      final dt = DateTime.fromMillisecondsSinceEpoch((h['dt'] ?? 0) * 1000);
      final dayKey = "${dt.year}-${dt.month}-${dt.day}";

      final tempValue = (h['main']?['temp'] ?? 0).toDouble();

      grouped.putIfAbsent(dayKey, () => []);
      grouped[dayKey]!.add(tempValue);
    }

    return grouped.values
        .take(7)
        .map((temps) => temps.reduce((a, b) => a + b) / temps.length)
        .toList();
  }

  List<String> extractWeekDays(List<dynamic> hourlyList) {
    final days = <String>[];
    final seen = <String>{};

    for (var h in hourlyList) {
      final dt = DateTime.fromMillisecondsSinceEpoch(h['dt'] * 1000);
      final label = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
      ][dt.weekday % 7];

      if (!seen.contains(label)) {
        seen.add(label);
        days.add(label);
      }
      if (days.length == 7) break;
    }

    return days;
  }

  String formatTime(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $ampm";
  }

  String timeAgo(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
    final diff = dt.difference(DateTime.now());

    if (diff.isNegative) {
      return "${diff.inHours.abs()}h ago";
    } else {
      return "in ${diff.inHours}h";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyTemps = extractDailyTemps(hourlyList);
    final days = extractWeekDays(hourlyList);
    final Size size = MediaQuery.of(context).size;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
      children: [
        InfoCardsSection(
          windSpeed: windSpeed,
          humidity: humidity,
          temp: temp,
          weather: weather,
        ),

        SizedBox(height: size.height * 0.01),
        HourForecastCard(
          hourlyList: hourlyList
        ),

        SizedBox(height: size.height * 0.01),
        DayForecastSection(
          temps: dailyTemps, 
          days: days
        ),

        SizedBox(height: size.height * 0.01),
        RainChanceCard(
          hourlyList: hourlyList
        ),

        SizedBox(height: size.height * 0.01),
        SunCardsSection(
          sunrise: sunrise,
          sunset: sunset,
          formatTime: formatTime,
          timeAgo: timeAgo,
        ),
      ],
    );
  }
}
