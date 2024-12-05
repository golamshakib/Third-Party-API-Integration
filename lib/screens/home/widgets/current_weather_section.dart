import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:third_party_api_integrations/utils/constants/sizes.dart';

import '../../../models/current_weather_model.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/texts/text_strings.dart';

class CurrentWeatherSection extends StatelessWidget {
  const CurrentWeatherSection({
    super.key,
    required this.currentWeatherModel,
    required this.symbol,
  });

  final CurrentWeatherModel currentWeatherModel;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(YSizes.spaceBtwItems),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${currentWeatherModel.name}, ${currentWeatherModel.sysCountry}',
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          Text(
              getFormatedDateTime(currentWeatherModel.dt!,
                  pattern: 'MMM d, yyyy'),
              style: const TextStyle(fontSize: 20.0)),
          Text(getFormatedDateTime(currentWeatherModel.dt!, pattern: 'EEEE'),
              style: const TextStyle(fontSize: 20.0)),
          Text(getFormatedDateTime(currentWeatherModel.dt!, pattern: 'hh:mm a'),
              style: const TextStyle(fontSize: 18.0)),
          const SizedBox(height: YSizes.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${currentWeatherModel.temp!.round()}$degree$symbol',
                    style: const TextStyle(
                        fontSize: 80.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: YSizes.spaceBtwItems),
                  _loadImage(context),
                ],
              ),
              const SizedBox(height: YSizes.sm),
              Row(
                children: [
                  Text(
                    'Feels like ${currentWeatherModel.feelsLike!.round()}$degree$symbol',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: YSizes.spaceBtwItems),
                  Text(
                    currentWeatherModel.weatherMain!,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Description: ${currentWeatherModel.weatherDescription!}',
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: YSizes.spaceBtwSections),
          Wrap(
            runSpacing: 2.0,
            children: [
              Text('Max ${currentWeatherModel.tempMax!.round()}$degree',
                  style: const TextStyle(fontSize: 20.0)),
              const SizedBox(width: 5.0),
              Text('Min ${currentWeatherModel.tempMin!.round()}$degree',
                  style: const TextStyle(fontSize: 20.0)),
              const SizedBox(width: 5.0),
              Text(
                  'Sunrise ${getFormatedDateTime(currentWeatherModel.sysSunrise!, pattern: 'hh:mm a')}',
                  style: const TextStyle(fontSize: 20.0)),
              const SizedBox(width: 5.0),
              Text(
                  'Sunset ${getFormatedDateTime(currentWeatherModel.sysSunset!, pattern: 'hh:mm a')}',
                  style: const TextStyle(fontSize: 20.0)),
              const SizedBox(width: 5.0),
              Text(
                  'Humidity ${getFormatedDateTime(currentWeatherModel.humidity!, pattern: 'hh:mm a')}',
                  style: const TextStyle(fontSize: 20.0)),
            ],
          ),
        ],
      ),
    );
  }
  Widget _loadImage(BuildContext context) {
    final isConnected = context.read<ConnectivityProvider>().isConnected;
    if (isConnected) {
      return Image.network(
        iconUrl(currentWeatherModel.weatherIcon!),
        width: 120.0,
        height: 120.0,
      );
    } else {
      return Image.asset('assets/images/placeholder.png');
    }
  }
}
