import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../common/widgets/appbar/custom_appbar.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/weather_provider.dart';
import '../../utils/constants/colors.dart';
import '../../utils/texts/text_strings.dart';
import '../settings/settings_screen.dart';
import 'widgets/weather_background.dart';
import 'widgets/weather_section.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// - Method to fetch weather data based on connection
  Future<void> _fetchWeatherData({bool useCurrentLocation = true}) async {
    final isConnected = context.read<ConnectivityProvider>().isConnected;
    if (isConnected) {
      final weatherProvider = context.read<WeatherProvider>();
      final tempStatus = await weatherProvider.getTempStatus();
      weatherProvider.updateUnit(tempStatus);
      if (useCurrentLocation) {
        await weatherProvider.detectDeviceLocation();
      }
      weatherProvider.getWeatherData(isConnected: isConnected);
    }
  }

  @override
  void initState() {
    super.initState();

    /// - Setup callback for connectivity restoration
    final connectivityProvider = context.read<ConnectivityProvider>();
    connectivityProvider.onConnectedCallback = () async {
      await _fetchWeatherData();
    };
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isConnected = context.read<ConnectivityProvider>().isConnected;
      if (isConnected) {
        _fetchWeatherData();
      }
    });

    return Scaffold(
      appBar: YCustomAppbar(
        backgroundColor: YColors.primary,
        title: Text(
          'Weather App',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: _fetchWeatherData,
            icon: const Icon(Iconsax.location),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: _CitySearchDelegate())
                  .then((city) {
                if (city != null && city.isNotEmpty) {
                  context.read<WeatherProvider>().convertCityToLatLong(city);
                }
              });
            },
            icon: const Icon(Iconsax.search_normal),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
            icon: const Icon(Iconsax.setting_2),
          ),
        ],
      ),
      body: Stack(
        children: [
          const WeatherBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ConnectivityProvider>(
                builder: (context, provider, child) {
                  if (!provider.isConnected) {
                    return Container(
                      width: double.infinity,
                      color: Colors.red.withOpacity(0.9),
                      padding: const EdgeInsets.all(6.0),
                      child: const Text(
                        "No Internet Connection",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _fetchWeatherData();
                  },
                  child: Consumer<WeatherProvider>(
                    builder: (context, provider, child) {
                      if (!provider.hasDataLoaded) {
                        return Center(
                          child: Text(
                            context.read<ConnectivityProvider>().isConnected
                                ? 'Please wait...'
                                : 'No Internet Connection',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        );
                      }
                      return WeatherSection(
                        currentWeatherModel: provider.currentWeatherModel!,
                        symbol: provider.unitSymbol,
                        isConnected: context.read<ConnectivityProvider>().isConnected,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      title: Text(query),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty
        ? majorCites
        : majorCites
        .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final city = filteredList[index];
        return ListTile(
          onTap: () {
            close(context, city);
          },
          title: Text(city),
        );
      },
    );
  }
}