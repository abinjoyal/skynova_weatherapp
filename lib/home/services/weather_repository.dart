import 'package:skynova/home/models/weather_model.dart';
import 'package:skynova/home/services/weather_service.dart';

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

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    final data = await _service.fetchWeatherByLocation(lat, lon);
    _cache = data;
    _cachedCity = data.location;
    return data;
  }

  Future<WeatherModel> getWeatherFromCurrentLocation() async {
    final position = await _service.getCurrentPosition();
    return await getWeatherByLocation(position.latitude, position.longitude);
  }

  void clearCache() {
    _cache = null;
    _cachedCity = null;
  }
}
