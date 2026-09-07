# 🌦️ Skynova Weather App

**Skynova** is a modern, responsive Flutter application designed to provide accurate real-time weather information, hourly forecasts, multi-day trends, and detailed atmospheric metrics in a clean, elegant UI.

---

## 💡 Project Concept & Features

* 📍 **Real-time Live Weather**: View current temperature, "feels like" metrics, weather conditions, wind speed, humidity, and exact sunrise/sunset times.
* 🔍 **Smart City Search**: Global city search powered by OpenWeatherMap Direct Geocoding API with real-time suggestions.
* 📊 **Multi-Tab Forecast Interface**:
  * **Today**: Detailed breakdown including hourly forecast carousel, chance of rain, and sun schedule cards.
  * **Tomorrow**: Summary of tomorrow's predicted climate metrics and conditions.
  * **7-Day Forecast**: Interactive temperature trend line graph (powered by `fl_chart`) paired with daily minimum and maximum temperature range bars.
* ⚡ **Performance & Caching**: Clean architecture utilizing a Repository Pattern to cache recent weather data and optimize network calls.
* 🎨 **Sleek Visual Experience**: Custom gradient headers, responsive dynamic layouts, and shimmer loading animations.

---

## 🛠️ Tech Stack & Architecture

* **Framework**: [Flutter](https://flutter.dev) (Dart)
* **API Integration**: OpenWeatherMap API (`/weather`, `/forecast`, `/geo`)
* **State & Data Handling**: Clean Architecture (Models, Services, Repository, UI Pages & Widgets)
* **Packages & Libraries**:
  * `fl_chart` — Interactive temperature graph
  * `shimmer` — Skeleton loading state animations
  * `http` — REST API requests
  * `intl` — Date & time formatting

---

## 🚀 Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/abinjoyal/skynova_weatherapp.git
   ```
2. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the application**:
   ```bash
   flutter run
   ```
