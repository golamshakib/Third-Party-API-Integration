import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:third_party_api_integrations/utils/texts/api_key.dart';

import '../db_helper/db_helper.dart';
import '../models/current_weather_model.dart';
import '../utils/texts/text_strings.dart';

class WeatherProvider with ChangeNotifier {
  CurrentWeatherModel? currentWeatherModel;
  final _db = DBHelper();

  double lat = 0.0, lon = 0.0;
  String unit = metric;
  String unitSymbol = celsius;
  String? _errorMessage;
  final _prefKey = 'status';

  /// - Update unit (Celsius / Fahrenheit)
  void updateUnit(bool value) {
    unit = value ? imperial : metric;
    unitSymbol = value ? fahrenheit : celsius;
  }

  /// - Getter
  String? get errorMessage => _errorMessage;

  bool get hasDataLoaded => currentWeatherModel != null;

  Future<void> detectDeviceLocation() async {
    final position = await _determinePosition();
    lat = position.latitude;
    lon = position.longitude;
  }

  /// - Set temperature status (Fahrenheit or Celsius)
  Future<void> setTempStatus(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_prefKey, value);
  }

  /// - Get temperature status from SharedPreferences
  Future<bool> getTempStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(_prefKey) ?? false;
  }

  /// - Convert City to Lat & Lon
  Future<void> convertCityToLatLong(String city) async {
    try {
      final locationList = await geo.locationFromAddress(city);
      if (locationList.isNotEmpty) {
        final location = locationList.first;
        lat = location.latitude;
        lon = location.longitude;
        await getWeatherData(isConnected: true);
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = 'Error converting city: ${error.toString()}';
      notifyListeners();
    }
  }

  /// - Fetch weather from the API
  Future<void> getWeatherData({required bool isConnected}) async {
    _errorMessage = null;
    notifyListeners();

    if (isConnected) {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=$unit&appid=${ApiKey.apiKey}';
      try {
        Response response = await get(Uri.parse(url));
        Map<String, dynamic> map = jsonDecode(response.body);
        if (response.statusCode == 200) {
          currentWeatherModel = CurrentWeatherModel.fromJson(map);

          // Cache the data into SQLite
          await _db.insertWeather(currentWeatherModel!);
        } else {
          _errorMessage = 'Failed to fetch weather: ${response.statusCode}';
        }
      } catch (e) {
        _errorMessage = 'Error fetching the data: ${e.toString()}';
        await loadCachedWeather();
      }
    } else {
      await loadCachedWeather();
    }
    notifyListeners();
  }

  /// - Load cached weather from SQLite
  Future<void> loadCachedWeather() async {
    final cachedData = await _db.getWeatherData();
    if (cachedData.isNotEmpty) {
      currentWeatherModel = cachedData.first;
    } else {
      _errorMessage = 'No cached data available.';
    }
    notifyListeners();
  }


  /// - Get current position of the device
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
