import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ClimateAlertApp());
}

class ClimateAlertApp extends StatelessWidget {
  const ClimateAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Climate Alert',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const ClimateAlertScreen(),
    );
  }
}

// ============================================================
// WEATHER MODEL
// ============================================================

class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });
}

// ============================================================
// MAIN SCREEN
// ============================================================

class ClimateAlertScreen extends StatefulWidget {
  const ClimateAlertScreen({super.key});

  @override
  State<ClimateAlertScreen> createState() => _ClimateAlertScreenState();
}

class _ClimateAlertScreenState extends State<ClimateAlertScreen> {
  final TextEditingController _cityController =
      TextEditingController(text: 'Chennai');

  WeatherData? weatherData;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    _searchWeather('Chennai');
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  // ==========================================================
  // SEARCH WEATHER
  // ==========================================================

  Future<void> _searchWeather(String city) async {
    if (city.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter a city name.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // ------------------------------------------------------
      // STEP 1: FIND CITY COORDINATES
      // ------------------------------------------------------

      final geoUrl = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search'
        '?name=${Uri.encodeComponent(city)}'
        '&count=1'
        '&language=en'
        '&format=json',
      );

      final geoResponse = await http.get(geoUrl);

      if (geoResponse.statusCode != 200) {
        throw Exception('Unable to find the city.');
      }

      final geoData = jsonDecode(geoResponse.body);

      if (geoData['results'] == null || geoData['results'].isEmpty) {
        throw Exception(
          'City not found. Please try another city.',
        );
      }

      final location = geoData['results'][0];

      final double latitude = (location['latitude'] as num).toDouble();

      final double longitude = (location['longitude'] as num).toDouble();

      final String cityName = location['name'] ?? city;

      final String country = location['country'] ?? '';

      // ------------------------------------------------------
      // STEP 2: GET WEATHER DATA
      // ------------------------------------------------------

      final weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&current=temperature_2m,relative_humidity_2m,'
        'apparent_temperature,wind_speed_10m,weather_code'
        '&timezone=auto',
      );

      final weatherResponse = await http.get(weatherUrl);

      if (weatherResponse.statusCode != 200) {
        throw Exception(
          'Unable to retrieve weather information.',
        );
      }

      final weatherJson = jsonDecode(weatherResponse.body);

      final current = weatherJson['current'];

      final WeatherData data = WeatherData(
        city: cityName,
        country: country,
        temperature: (current['temperature_2m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
        weatherCode: (current['weather_code'] as num).toInt(),
      );

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ==========================================================
  // SEARCH BUTTON
  // ==========================================================

  void _performSearch() {
    FocusScope.of(context).unfocus();

    _searchWeather(_cityController.text);
  }

  // ==========================================================
  // WEATHER DESCRIPTION
  // ==========================================================

  String _weatherDescription(int code) {
    if (code == 0) {
      return 'Clear Sky';
    } else if (code <= 3) {
      return 'Partly Cloudy';
    } else if (code <= 48) {
      return 'Foggy';
    } else if (code <= 57) {
      return 'Drizzle';
    } else if (code <= 67) {
      return 'Rainy';
    } else if (code <= 77) {
      return 'Snowy';
    } else if (code <= 82) {
      return 'Rain Showers';
    } else if (code <= 86) {
      return 'Snow Showers';
    } else if (code >= 95) {
      return 'Thunderstorm';
    }

    return 'Cloudy';
  }

  // ==========================================================
  // WEATHER ICON
  // ==========================================================

  IconData _weatherIcon(int code) {
    if (code == 0) {
      return Icons.wb_sunny;
    } else if (code <= 3) {
      return Icons.cloud;
    } else if (code <= 48) {
      return Icons.cloud;
    } else if (code <= 67) {
      return Icons.water_drop;
    } else if (code <= 82) {
      return Icons.umbrella;
    } else if (code >= 95) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  // ==========================================================
  // ALERT TITLE
  // ==========================================================

  String _alertTitle() {
    if (weatherData == null) {
      return 'CLIMATE ALERT';
    }

    if (weatherData!.temperature >= 38) {
      return 'EXTREME HEAT ALERT';
    }

    if (weatherData!.temperature >= 35) {
      return 'HIGH HEAT ALERT';
    }

    if (weatherData!.weatherCode >= 95) {
      return 'STORM ALERT';
    }

    if (weatherData!.weatherCode >= 61) {
      return 'RAIN ALERT';
    }

    return 'WEATHER UPDATE';
  }

  // ==========================================================
  // ALERT DESCRIPTION
  // ==========================================================

  String _alertDescription() {
    if (weatherData == null) {
      return '';
    }

    if (weatherData!.temperature >= 38) {
      return 'Extreme temperature detected. '
          'Avoid prolonged outdoor activities and stay hydrated.';
    }

    if (weatherData!.temperature >= 35) {
      return 'High temperature detected. '
          'Drink plenty of water and avoid direct sunlight.';
    }

    if (weatherData!.weatherCode >= 95) {
      return 'Thunderstorm conditions detected. '
          'Avoid open areas and stay indoors when possible.';
    }

    if (weatherData!.weatherCode >= 61) {
      return 'Rain conditions detected. '
          'Carry an umbrella and travel carefully.';
    }

    return 'Weather conditions are currently comfortable. '
        'Continue to follow normal safety precautions.';
  }

  // ==========================================================
  // BACKGROUND
  // ==========================================================

  BoxDecoration _backgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF071E3D),
          Color(0xFF0D4F6E),
          Color(0xFF159A9C),
        ],
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _backgroundDecoration(),
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final bool isPortrait = orientation == Orientation.portrait;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    if (isLoading)
                      _buildLoading()
                    else if (errorMessage != null)
                      _buildError()
                    else if (weatherData != null)
                      isPortrait
                          ? _buildPortraitLayout()
                          : _buildLandscapeLayout(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.cloud_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CLIMATE ALERT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Real-time weather information',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SEARCH BAR
  // ==========================================================

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.white70,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _cityController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter city name',
                hintStyle: TextStyle(
                  color: Colors.white54,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (_) {
                _performSearch();
              },
            ),
          ),
          IconButton(
            onPressed: _performSearch,
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PORTRAIT LAYOUT
  // ==========================================================

  Widget _buildPortraitLayout() {
    return Column(
      children: [
        _buildWeatherCard(),
        const SizedBox(height: 18),
        _buildAlertCard(),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${weatherData!.humidity}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.air,
                title: 'Wind',
                value: '${weatherData!.windSpeed.toStringAsFixed(1)} km/h',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _buildSafetySection(),
      ],
    );
  }

  // ==========================================================
  // LANDSCAPE LAYOUT
  // ==========================================================

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildWeatherCard(),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildAlertCard(),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.water_drop,
                      title: 'Humidity',
                      value: '${weatherData!.humidity}%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.air,
                      title: 'Wind',
                      value:
                          '${weatherData!.windSpeed.toStringAsFixed(1)} km/h',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 3,
          child: _buildSafetySection(),
        ),
      ],
    );
  }

  // ==========================================================
  // WEATHER CARD
  // ==========================================================

  Widget _buildWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Column(
        children: [
          Icon(
            _weatherIcon(weatherData!.weatherCode),
            color: const Color(0xFFFFD166),
            size: 50,
          ),
          const SizedBox(height: 8),
          Text(
            _weatherDescription(
              weatherData!.weatherCode,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${weatherData!.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 55,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Feels like ${weatherData!.feelsLike.toStringAsFixed(1)}°C',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${weatherData!.city}, ${weatherData!.country}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ALERT CARD
  // ==========================================================

  Widget _buildAlertCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE76F51),
            Color(0xFFF4A261),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _alertTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _alertDescription(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFO CARD
  // ==========================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF90E0EF),
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SAFETY TIPS
  // ==========================================================

  Widget _buildSafetySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                color: Color(0xFF90E0EF),
                size: 27,
              ),
              SizedBox(width: 9),
              Text(
                'Safety Tips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildTip(
            Icons.water_drop_outlined,
            'Stay hydrated',
          ),
          _buildTip(
            Icons.wb_sunny_outlined,
            'Avoid prolonged direct sunlight',
          ),
          _buildTip(
            Icons.health_and_safety_outlined,
            'Follow local weather warnings',
          ),
          _buildTip(
            Icons.access_time,
            'Plan outdoor activities carefully',
          ),
        ],
      ),
    );
  }

  Widget _buildTip(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // LOADING
  // ==========================================================

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 18),
          Text(
            'Getting weather information...',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  Widget _buildError() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.redAccent.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 45,
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _searchWeather(_cityController.text);
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
