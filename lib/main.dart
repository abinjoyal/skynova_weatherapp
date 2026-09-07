import 'package:flutter/material.dart';
import 'package:skynova/home/models/weather_model.dart';
import 'package:skynova/home/pages/home_page.dart';
import 'package:skynova/home/services/weather_repository.dart';
import 'package:skynova/home/widgets/weather_shimmer.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WeatherRepository repo = WeatherRepository();

  late Future<WeatherModel> futureWeather;

  String currentCity = "Kanyakumari, Tamil Nadu, IN";
  String lastValidCity = "Kanyakumari, Tamil Nadu, IN";

  @override
  void initState() {
    super.initState();
    futureWeather = repo.getWeather(currentCity.split(",").first.trim());
  }

  void updateCity(String newCity) {
    if (newCity.isEmpty) return;

    setState(() {
      lastValidCity = currentCity;
      currentCity = newCity;

      // API uses only city name
      futureWeather = repo.getWeather(newCity.split(",").first.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherModel>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const WeatherShimmer();
          }

          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      currentCity = lastValidCity;
                      futureWeather = repo.getWeather(
                        lastValidCity.split(",").first.trim(),
                      );
                    });
                  },
                ),
                title: const Text("Weather App"),
              ),
              body: const Center(child: Text("City not found")),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data"));
          }

          final data = snapshot.data!;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: HomePage(
              key: ValueKey(currentCity),
              location: currentCity, 
              temp: data.temp,
              tempMin: data.tempMin,
              tempMax: data.tempMax,
              weather: data.weather,
              humidity: data.humidity,
              windSpeed: data.windSpeed,
              feelsLike: data.feelsLike,
              sunrise: data.sunrise,
              sunset: data.sunset,
              icon: data.icon,
              hourlyList: data.hourlyList,
              daily: data.daily,
              onCityChanged: updateCity,
            ),
          );
        },
      ),
    );
  }
}
