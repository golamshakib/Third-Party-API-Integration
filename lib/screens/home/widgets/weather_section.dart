import 'package:flutter/material.dart';

import '../../../models/current_weather_model.dart';
import 'current_weather_section.dart';

class WeatherSection extends StatelessWidget {
  const WeatherSection({
    super.key,
    required this.currentWeatherModel,
    required this.symbol,
    required this.isConnected,
  });

  final CurrentWeatherModel currentWeatherModel;

  final String symbol;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: CurrentWeatherSection(
              currentWeatherModel: currentWeatherModel, symbol: symbol),
        ),
      ],
    );
  }
}