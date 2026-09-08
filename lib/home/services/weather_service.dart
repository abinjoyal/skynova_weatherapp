import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  /// WEATHER DATA BY CITY
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

  /// WEATHER DATA BY LATITUDE / LONGITUDE
  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    final currentUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final currentRes = await http.get(Uri.parse(currentUrl));
    final forecastRes = await http.get(Uri.parse(forecastUrl));

    if (currentRes.statusCode != 200) {
      throw Exception("Failed to fetch weather for current location");
    }

    final currentJson = jsonDecode(currentRes.body);
    final forecastJson = jsonDecode(forecastRes.body);

    final locationName = currentJson['name'] != null
        ? "${currentJson['name']}, ${currentJson['sys']['country']}"
        : "Current Location";

    return WeatherModel.fromJSON(
      currentJson,
      forecastJson,
      forecastJson,
      locationName,
    );
  }

  /// GET DEVICE GPS POSITION
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location permissions are permanently denied, cannot request permissions.",
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
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
