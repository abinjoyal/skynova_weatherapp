class TendaysModel {
  final String dayName;
  final String dateLabel;
  final String condition;
  final double maxTemp;
  final double minTemp;
  final String icon;

  TendaysModel({
    required this.dayName,
    required this.dateLabel,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
  });

  factory TendaysModel.fromJson(Map<String, dynamic> json) {
    final dt = DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000);

    const days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    final condition = json['weather']?[0]?['main'] ?? "Clear";
    final iconCode = json['weather']?[0]?['icon'] ?? "01d";

    return TendaysModel(
      dayName: days[dt.weekday - 1],   // auto cycles
      dateLabel: "${dt.day} ${months[dt.month - 1]}",
      condition: condition,
      maxTemp: ((json['main']?['temp_max']) ?? 0).toDouble(),
      minTemp: ((json['main']?['temp_min']) ?? 0).toDouble(),
      icon: "https://openweathermap.org/img/wn/$iconCode@2x.png",
    );
  }
}
