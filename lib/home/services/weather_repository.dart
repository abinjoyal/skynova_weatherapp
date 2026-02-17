import 'package:flutter_application_5/home/models/weather_model.dart';
import 'package:flutter_application_5/home/services/weather_service.dart';

class WeatherRepository {
  final WeatherService _service = WeatherService();

  WeatherModel? _cache;
  String? _cachedCity;

  Future<WeatherModel> getWeather(String city) async {
  
    if (_cache != null && city == _cachedCity) {
      return _cache!;
    }

    final data = await _service.fetchWeather(city);

    _cache = data;
    _cachedCity = city;

    return data;
  }

  void clearCache() {
    _cache = null;
    _cachedCity = null;
  }
}
