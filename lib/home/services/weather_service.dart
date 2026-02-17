import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const apiKey = "301e1c7714f72f1a2643647214ea682e";

  /// WEATHER DATA
  Future<WeatherModel> fetchWeather(String city) async {
    final currentUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=${city.split(',').first}&appid=$apiKey&units=metric";

    final forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?q=${city.split(',').first}&appid=$apiKey&units=metric";

    final currentRes = await http.get(Uri.parse(currentUrl));
    final forecastRes = await http.get(Uri.parse(forecastUrl));

    if (currentRes.statusCode != 200) {
      throw Exception("city not found");
    }

    final currentJson = jsonDecode(currentRes.body);
    final forecastJson = jsonDecode(forecastRes.body);

    return WeatherModel.fromJSON(currentJson, forecastJson, forecastJson, city);
  }

  /// CITY SEARCH SUGGESTIONS
  Future<List<String>> fetchCitySuggestions(String query) async {
    final url =
        "https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return List<String>.from(
        data.map(
          (city) =>
              "${city['name']}, ${city['state'] ?? ''}, ${city['country']}",
        ),
      );
    }

    return [];
  }
}
