import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skynova/home/models/weather_model.dart';
import 'package:skynova/home/pages/home_page.dart';
import 'package:skynova/home/services/weather_repository.dart';
import 'package:skynova/home/widgets/weather_shimmer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
    _loadInitialWeather();
  }

  void _loadInitialWeather() {
    setState(() {
      futureWeather = repo.getWeatherFromCurrentLocation().then((data) {
        setState(() {
          currentCity = data.location;
          lastValidCity = data.location;
        });
        return data;
      }).catchError((_) {
        // Fallback to default city if GPS location fails or permissions denied
        return repo.getWeather("Kanyakumari");
      });
    });
  }

  void updateCity(String newCity) {
    if (newCity.isEmpty) return;

    setState(() {
      if (newCity == "USE_CURRENT_LOCATION") {
        futureWeather = repo.getWeatherFromCurrentLocation().then((data) {
          setState(() {
            currentCity = data.location;
            lastValidCity = data.location;
          });
          return data;
        }).catchError((err) {
          final errorMsg = err.toString().replaceAll("Exception: ", "");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("GPS Location Error: $errorMsg"),
                backgroundColor: Colors.deepOrange,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          final fallbackCity = (lastValidCity == "USE_CURRENT_LOCATION" || lastValidCity.isEmpty)
              ? "Kanyakumari"
              : lastValidCity.split(",").first.trim();
          return repo.getWeather(fallbackCity);
        });
      } else {
        final cleanCity = newCity.split(",").first.trim();
        futureWeather = repo.getWeather(cleanCity).then((data) {
          setState(() {
            lastValidCity = currentCity;
            currentCity = newCity;
          });
          return data;
        });
      }
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
                      final fallback = (lastValidCity == "USE_CURRENT_LOCATION" || lastValidCity.isEmpty)
                          ? "Kanyakumari"
                          : lastValidCity.split(",").first.trim();
                      currentCity = fallback;
                      futureWeather = repo.getWeather(fallback);
                    });
                  },
                ),
                title: const Text("Weather App"),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off_outlined, size: 56, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text(
                        snapshot.error.toString().replaceAll("Exception: ", ""),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text("Load Default City"),
                        onPressed: () {
                          setState(() {
                            currentCity = "Kanyakumari";
                            lastValidCity = "Kanyakumari";
                            futureWeather = repo.getWeather("Kanyakumari");
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
