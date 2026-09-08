import 'package:flutter/material.dart';
import 'package:skynova/home/services/weather_service.dart';

class CitySearchDelegate extends SearchDelegate<String> {
  final WeatherService service = WeatherService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ""), // no change
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(child: Text("Select a city from suggestions"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.my_location, color: Colors.blue),
            title: const Text("Use Current Location"),
            onTap: () {
              close(context, "USE_CURRENT_LOCATION");
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text("Type city name to search")),
          ),
        ],
      );
    }

    return FutureBuilder<List<String>>(
      future: service.fetchCitySuggestions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No cities found"));
        }

        final cities = snapshot.data!;

        return ListView.builder(
          itemCount: cities.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                leading: const Icon(Icons.my_location, color: Colors.blue),
                title: const Text("Use Current Location"),
                onTap: () {
                  close(context, "USE_CURRENT_LOCATION");
                },
              );
            }

            final displayText = cities[index - 1];

            return ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(displayText),
              onTap: () {
                close(context, displayText);
              },
            );
          },
        );
      },
    );
  }
}
