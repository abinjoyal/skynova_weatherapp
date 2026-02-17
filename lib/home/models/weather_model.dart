import 'package:flutter_application_5/home/models/tendays_model.dart';

class WeatherModel {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final int humidity;
  final double feelsLike;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final String icon;
  final List<dynamic> hourlyList;
  final List<TendaysModel> daily;

  WeatherModel({
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
    required this.hourlyList,
    required this.daily,
  });

  factory WeatherModel.fromJSON(
    Map<String, dynamic> currentJson,
    Map<String, dynamic> forecastJson,
    Map<String, dynamic> oneCallJson,
    String locationName,
  ) {
    final List forecastList = forecastJson['list'];

    final Map<String, dynamic> dailyMap = {};

    for (var item in forecastList) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);

      final key = "${date.year}-${date.month}-${date.day}";

      if (!dailyMap.containsKey(key)) {
        dailyMap[key] = item;
      }
    }

    final List<TendaysModel> dailyForecast = dailyMap.values.take(10).map((
      item,
    ) {
      return TendaysModel.fromJson(item);
    }).toList();

    return WeatherModel(
      location: locationName,
      temp: (currentJson['main']['temp']).toDouble(),
      tempMin: (currentJson['main']['temp_min']).toDouble(),
      tempMax: (currentJson['main']['temp_max']).toDouble(),
      weather: currentJson['weather'][0]['main'],
      humidity: currentJson['main']['humidity'],
      windSpeed: (currentJson['wind']['speed']).toDouble(),
      feelsLike: (currentJson['main']['feels_like']).toDouble(),
      sunrise: currentJson['sys']['sunrise'],
      sunset: currentJson['sys']['sunset'],
      icon: currentJson['weather'][0]['icon'],
      hourlyList: forecastJson['list'] ?? [],
      daily: dailyForecast,
    );
  }
}
