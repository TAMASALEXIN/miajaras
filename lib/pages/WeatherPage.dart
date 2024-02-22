import 'package:flutter/material.dart';
import 'package:miajaras/services/weather_service.dart';
import 'package:miajaras/models/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService =
      WeatherService(apiKey: '3f4a0e66a48659c0df5f48e3ec8e81ab');
  Weather? _weather;

  // weather animations

  String getWeatherAnimation(String? condition) {
    switch (condition) {
      case 'Rain':
      case 'Drizzle':
      case 'showers rain':
        return 'Rainy.json';
      case 'Clouds':
        return 'Clouds.json';
      case 'Clear':
        return 'Sunny.json';
      case 'thunderstorm':
        return 'Storm.json';
      case 'Mist':
      case 'Fog':
      case 'Haze':
      case 'Smoke':
      case 'Dust':
        return 'Misty.json';

      default:
        return 'Sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    // fetch the weather data when starting
    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi a jaras?'),
        centerTitle: true,
        backgroundColor: Colors.teal[400],
      ),
      body: FutureBuilder<Weather>(
        future: _getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _weather = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // City name
                  Text(
                    _weather?.location ?? 'Unknown',
                    style: const TextStyle(fontSize: 30),
                  ),
                  // Animation
                  Lottie.asset(
                    'assets/${getWeatherAnimation(_weather?.condition)}',
                  ),

                  // Temperature
                  Text(
                    '${_weather?.temperature.round()}°C',
                    style: const TextStyle(fontSize: 30),
                  ),
                  // Condition
                  Text(
                    _weather?.condition ?? 'Unknown',
                    style: const TextStyle(fontSize: 30),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Weather> _getWeather() async {
    String cityname = await _weatherService.currentCity();
    return await _weatherService.getWeather(cityname);
  }
}
