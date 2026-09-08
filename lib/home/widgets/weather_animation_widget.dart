import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skynova/home/theme/colors.dart';

class WeatherAnimationWidget extends StatelessWidget {
  final String weather;

  const WeatherAnimationWidget({super.key, required this.weather});

  String _getLottieUrl(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain') || lower.contains('drizzle')) {
      return 'https://assets3.lottiefiles.com/packages/lf20_jm7z8v.json';
    } else if (lower.contains('cloud')) {
      return 'https://assets5.lottiefiles.com/packages/lf20_k1u3f2.json';
    } else if (lower.contains('clear') || lower.contains('sun')) {
      return 'https://assets4.lottiefiles.com/packages/lf20_xlzxey.json';
    } else if (lower.contains('snow')) {
      return 'https://assets8.lottiefiles.com/packages/lf20_rh9z7c.json';
    } else if (lower.contains('thunder') || lower.contains('storm')) {
      return 'https://assets9.lottiefiles.com/packages/lf20_t9gkkh.json';
    }
    // Default sunny/clear
    return 'https://assets4.lottiefiles.com/packages/lf20_xlzxey.json';
  }

  List<Color> getGradientColors(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain') || lower.contains('drizzle')) {
      return [const Color(0xFF2C3E50), const Color(0xFF4CA1AF)];
    } else if (lower.contains('cloud')) {
      return [const Color(0xFF536976), const Color(0xFF292E49)];
    } else if (lower.contains('clear') || lower.contains('sun')) {
      return [AppColors.primaryStart, AppColors.primaryEnd];
    } else if (lower.contains('thunder') || lower.contains('storm')) {
      return [const Color(0xFF1F1C2C), const Color(0xFF928DAB)];
    } else if (lower.contains('snow')) {
      return [const Color(0xFF83a4d4), const Color(0xFFb6fbff)];
    }
    return [AppColors.primaryStart, AppColors.primaryEnd];
  }

  @override
  Widget build(BuildContext context) {
    final lottieUrl = _getLottieUrl(weather);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Dynamic Gradient Overlay
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: getGradientColors(weather),
              ),
            ),
          ),

          // Floating Lottie Weather Animation
          Positioned(
            right: -20,
            bottom: -20,
            width: 180,
            height: 180,
            child: Opacity(
              opacity: 0.85,
              child: Lottie.network(
                lottieUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
